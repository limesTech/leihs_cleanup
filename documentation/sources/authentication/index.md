Authentication in _leihs_
=========================

The authentication within _leihs_ has been rewritten in version 5. 
The new design provides two internal authentication methods:

1. password authentication (rewritten and available as of version 5.0) ,
2. e-mail authentication (planned for version 5.1), and 

any number of _external authentication systems_ which can be bound to leihs via
an API which is similar to [OAuth](https://oauth.net/). 

Before version 5.0 binding custom authentication systems to _leihs_ required
custom code to be integrated within leihs. Such an approach is neither
necessary nor intended from _leihs_ 5.0 on.

The reminder of this document discusses mostly _external authentication
systems_. 


## _External Authentication Systems_ in _leihs_

An external authentication system consist of an **HTTP service** and a
corresponding **configuration in _leihs_**. The role of the external service is to
assert that a user who desires to sign in to _leihs_ is who he or she claims to
be and forward this assertion to _leihs_. 

### The Flow of Data during a Sign-in Process as an Example

The following steps are carried out during a successful sign in process when
using an _external authentication sytem_. 

1. A currently not signed in user provides his identity (either in the form of
   the `email`, `login`, or `org_id`) and requests to sign in.

2. Leihs evaluates this requests and offers available authentication methods 
  for the particular user. 

3. The user proceeds for example with an external authentication system.

4. _leihs_ prepares an _authentication token_ and forwards the user to the 
  external service via an HTTP redirect (sending the token via URL parameters).  

5. The external authentication system will (in general first) _verify origin_
   and _validity_ of the token. 
   
6. The external service performs authentication of he user.

7. The external service creates a further token which proves successful
   authentication and redirects the user back to _leihs_. 

8. _leihs_ will _verify origin_ and _validity_ of the token and sign the user in.

The procedure state above is the most general case. _leihs_ can shortcut steps
and follow simpler procedures in some cases. 


### Some Key Properties of (not only external) authentication with _leihs_

* An external authentication system is bound to leihs with a public/private key
  pair (PKI) and via an URL. 

* For every external there is also a public/private key pair in _leihs_.  

* This allows the external authentication system to be controlled and run 
  independently of leihs. This setup (and the communication based purely 
  on redirects) _tolerates firewalls_. 

* It is possible to use one leihs key pair for multiple external authentication
  systems. It is also possible to use the same key pair in leihs and in the 
  external authentication system. The latter case is equivalent to using a
  shared secret between leihs and the external authentication system which
  might be enough in some simple cases.

* The tokens send forth and back to leihs follow the [JWT](https://jwt.io/)
  standard.

* Leihs supports `EC256` keys, see also [JWT](https://jwt.io/).

* Users are associated directly or via groups to authentication systems in
  _leihs._ 

