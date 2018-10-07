Encoding
----------
(**URLENCODE** string &key (**queryp** nil)) → string

**queryp** : If true you get application/x-www-form-urlencoded.

Decoding
----------
(**URLDECODE** string &key (**queryp** nil)) → string

**queryp** : If true you get application/x-www-form-urlencoded.  

May signal conditions from babel if UTF-8 encoding/decoding fails.
