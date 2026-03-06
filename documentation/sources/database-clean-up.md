DB Clean-UP
===========


Table Size
----------

    SELECT *, pg_size_pretty(total_bytes) AS total
        , pg_size_pretty(index_bytes) AS INDEX
        , pg_size_pretty(toast_bytes) AS toast
        , pg_size_pretty(table_bytes) AS TABLE
      FROM (
      SELECT *, total_bytes-index_bytes-COALESCE(toast_bytes,0) AS table_bytes FROM (
          SELECT c.oid,nspname AS table_schema, relname AS TABLE_NAME
                  , c.reltuples AS row_estimate
                  , pg_total_relation_size(c.oid) AS total_bytes
                  , pg_indexes_size(c.oid) AS index_bytes
                  , pg_total_relation_size(reltoastrelid) AS toast_bytes
              FROM pg_class c
              LEFT JOIN pg_namespace n ON n.oid = c.relnamespace
              WHERE relkind = 'r'
      ) a
    ) a ORDER BY total_bytes DESC limit 10;


      oid  | table_schema |       table_name        | row_estimate | total_bytes | index_bytes | toast_bytes | table_bytes |  total  |  index  |   toast    |  table
    -------+--------------+-------------------------+--------------+-------------+-------------+-------------+-------------+---------+---------+------------+---------
     35630 | public       | attachments             |         1155 |  3226804224 |      163840 |  3225157632 |     1482752 | 3077 MB | 160 kB  | 3076 MB    | 1448 kB
     35637 | public       | audits                  |  1.85985e+06 |  2082299904 |   416661504 |  1071218688 |   594419712 | 1986 MB | 397 MB  | 1022 MB    | 567 MB
     35760 | public       | images                  |        10514 |   612950016 |      794624 |   601235456 |    10919936 | 585 MB  | 776 kB  | 573 MB     | 10 MB
     36020 | public       | reservations            |       395894 |   203489280 |   120111104 |        8192 |    83369984 | 194 MB  | 115 MB  | 8192 bytes | 80 MB
     35883 | public       | procurement_attachments |          151 |    90521600 |       16384 |    90267648 |      237568 | 86 MB   | 16 kB   | 86 MB      | 232 kB
     35842 | public       | notifications           |       287460 |    60489728 |    29884416 |        8192 |    30597120 | 58 MB   | 29 MB   | 8192 bytes | 29 MB
     35688 | public       | contracts               |        88814 |    36945920 |    14499840 |       57344 |    22388736 | 35 MB   | 14 MB   | 56 kB      | 21 MB
     35782 | public       | items                   |        34246 |    25657344 |    12435456 |       81920 |    13139968 | 24 MB   | 12 MB   | 80 kB      | 13 MB
     35869 | public       | orders                  |        71381 |    20750336 |    10731520 |        8192 |    10010624 | 20 MB   | 10 MB   | 8192 bytes | 9776 kB
     36089 | public       | users                   |        11278 |    17907712 |     5824512 |        8192 |    12075008 | 17 MB   | 5688 kB | 8192 bytes | 12 MB


`attachments` und `audits` sind grosse Tabellen. `attachments` ist gross
bezüglich Datenverbrauch. `audits` ist gross bezüglich Anzahl der Zeilen und
Indizes.


Audits
------


Alle `audits` älter als ein Jahr Löschen:

    DELETE FROM audits WHERE created_at < now() - '1 Year'::interval;

Spart um die 1.2 GB und vor allem Indizes:

      oid  | table_schema |       table_name        | row_estimate | total_bytes | index_bytes | toast_bytes | table_bytes |  total  |  index  |   toast    |  table
    -------+--------------+-------------------------+--------------+-------------+-------------+-------------+-------------+---------+---------+------------+---------
     35630 | public       | attachments             |         1155 |  3225862144 |      163840 |  3224256512 |     1441792 | 3076 MB | 160 kB  | 3075 MB    | 1408 kB
     35637 | public       | audits                  |       484857 |   812990464 |   108748800 |   531595264 |   172646400 | 775 MB  | 104 MB  | 507 MB     | 165 MB


Attachments
-----------

Nicht (mehr) benutze Attachments:

   SELECT filename, content_type, size FROM attachments
          WHERE model_id IS NOT NULL
          AND NOT EXISTS (SELECT 1 FROM models
                                   INNER JOIN items ON items.model_id = models.id
                                          WHERE attachments.model_id = models.id
                                          AND items.retired IS NOT NULL)
          order by size DESC;


Löschen: 

    DELETE FROM attachments
          WHERE model_id IS NOT NULL
          AND NOT EXISTS (SELECT 1 FROM models
                                   INNER JOIN items ON items.model_id = models.id
                                          WHERE attachments.model_id = models.id
                                          AND items.retired IS NOT NULL);

    DELETE 519

Spart knapp 2 GB: 

      oid  | table_schema |       table_name        | row_estimate | total_bytes | index_bytes | toast_bytes | table_bytes |  total  |  index  |   toast    |  table
    -------+--------------+-------------------------+--------------+-------------+-------------+-------------+-------------+---------+---------+------------+---------
     35630 | public       | attachments             |          636 |  1340153856 |      114688 |  1339179008 |      860160 | 1278 MB | 112 kB  | 1277 MB    | 840 kB
     35637 | public       | audits                  |       484857 |   812834816 |   108748800 |   531439616 |   172646400 | 775 MB  | 104 MB  | 507 MB     | 165 MB
