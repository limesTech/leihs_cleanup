
# Replace Existing "Audits"

## State

* Audits depend on a Gem which depends on Rails-Hooks.

### The Bad

* Not reliable.
* System can be easily or by accident circumvented.
* Can be easily forged.
* Every webapp would have to implement it itself.

### The Good

* Fairly simple: one table, some resilient (well...) magic to interpret it.


## Idea


* Shadow tables are posible but they are very far from what we use now.
    They seem to cause more expenditure in the UI/UX.

* Store in one Table `audits2` (or whatever)
    * row data as JSON
    * table_name or something

* Add created_by, updated_by, and request_id to every table we want to audit,
    webapps must set proper values here

* Possibly later: log and STORE web requests, too.


### Some Disadvantages

* Deletes are not associated with any user or request_іd. Mitigation: don't
    delete. We are lucky because leihs mostly works this way already.

* Need to write a new UI.


### Good

* Roundabout as simple as before.


## Technical

### Postgresql

Rows can be converted to JSON:

    SELECT row_to_json(users) FROM users;


### Apache

Request IDs <http://httpd.apache.org/docs/current/mod/mod_unique_id.html>
