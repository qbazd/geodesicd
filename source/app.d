import std.stdio;

import geodesicd;

void main()
{
    Geodesic g;

    double a = 6378137, f = 1/298.257223563; /* WGS84 */
    double lat1, lon1, azi1, lat2, lon2, azi2, s12;

    lat1 = 54.5;
    lon1 = 18.5;
    lat2 = 55.5;
    lon2 = 17.5;
/*

    writefln("Current process id: %s", getpid());
    auto x = mean(1.0,3.0);
    writefln("%f".format(x));

    geod_geodesic g;
    geod_init(&g,a,f);
    geod_inverse(&g, lat1, lon1, lat2, lon2, &s12, &azi1, &azi2);

    //set_double(0.1, &azi1);
    writeln("azi1 ", g.sizeof );
    writeln("%.15f %.15f %.10f".format(s12, azi1, azi2));
*/
    auto g1 = new Geodesic(a,f);
    auto g_out1 = g1.inverse(lat1, lon1, lat2, lon2);
    writeln(g_out1);
    auto g_out2 = g1.direct(lat1, lon1, 90.0, 50000.0);

    writeln(g_out2);

    auto dd = g1.direct(lat1, lon1, 90.0, 50000.0);
    writeln(dd);

/+
    foreach ( a1, b1; zip(dd, dd))
    //foreach (vv; dd)
    {
        writeln("%f,%f".format(a1,b1));
    }
+/
	writeln("Edit source/app.d to start your project.");
}
