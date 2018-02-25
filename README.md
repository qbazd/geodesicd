GeodesicD
=========

dlang warper for Geodesic part of [GeographicLib 1.49](https://geographiclib.sourceforge.io/).
[D Programming Language](http://dlang.org).

The simple warper of inverse and direct functions.

Example
-------

```dlang

import geodesicd;
auto g1 = Geodesic(EllipsoidWGS84);
auto p1 = LatLon(54.5, 18.5);
auto p2 = LatLon(55.5, 17.5);
auto g_out1 = g1.inverse(p1, p2);

auto g_out2 = g1.direct(p1, AzDist(90.0, 50000.0));

```

Dependencies
------------
- dlang compiler
- GCC - used for compilation of original geodesic C library as static library

TODO
----

- rest of geodesic library
- rewrite unittests from geodtest.c



