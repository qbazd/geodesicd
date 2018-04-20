module geodesicd.geodesic_wraper;

private
{

  extern(C){

  struct geod_geodesic {
    double a;         
    double f;         
    double f1; 
    double e2; 
    double ep2; 
    double n; 
    double b; 
    double c2; 
    double etol2;
    double[6] A3x;
    double[15] C3x;
    double[21] C4x;
  };

  void geod_init( geod_geodesic* g, double a, double f);

  void geod_inverse(const geod_geodesic* g,
            double lat1, double lon1, double lat2, double lon2,
            double* ps12, double* pazi1, double* pazi2);

  void geod_direct(const geod_geodesic* g,
           double lat1, double lon1, double azi1, double s12,
           double* plat2, double* plon2, double* pazi2);

  }

}
// WGS84 as default;
struct Ellipsoid{
  double a = 6378137;
  double f = 1/298.257223563; 
}

struct LatLon{
  double lat = 0.0;
  double lon = 0.0;
}

struct AzDist{
  double az = 0.0;
  double distance = 0.0;
}

struct LatLonAz{
  double lat = 0.0;
  double lon = 0.0;
  double az = 0.0;  
}

struct DistAz1Az2{
  double distance = 0.0;
  double az1 = 0.0;  
  double az2 = 0.0;  
}

static Ellipsoid EllipsoidWGS84 = {6378137, 1/298.257223563};

// D wraper
struct Geodesic{

  private geod_geodesic g;
  private Ellipsoid ellipsoid;
  
  this(double a, double f){
     ellipsoid.a=a;
     ellipsoid.f=f;
     geod_init(&g, ellipsoid.a, ellipsoid.f);
  }
  
  this(Ellipsoid e){
    ellipsoid = e;
    geod_init(&g,ellipsoid.a,ellipsoid.f);
  }

  double[3] inverse(double lat1, double lon1, double lat2, double lon2){
    double[3] v;
    geod_inverse(&this.g, lat1, lon1, lat2, lon2, &v[0], &v[1], &v[2]);
    return v;
  }

  DistAz1Az2 inverse(LatLon p1, LatLon p2){
    DistAz1Az2 v;
    geod_inverse(&this.g, p1.lat, p1.lon, p2.lat, p2.lon, &v.distance, &v.az1, &v.az2);
    return v;
  }

  double[3] direct(double lat1, double lon1, double azi1, double s12){
    double[3] v;
    geod_direct(&this.g, lat1, lon1, azi1, s12, &v[0], &v[1], &v[2]);
    return v;
  }

  LatLonAz direct(LatLon p1, AzDist azd){
    LatLonAz v;
    geod_direct(&this.g, p1.lat, p1.lon, azd.az, azd.distance, &v.lat, &v.lon, &v.az);
    return v;
  }

}

// test init!
unittest{
  import std.stdio;
  auto g1 = Geodesic();
  auto g2 = Geodesic(6378137, 1/298.257223563);
  auto g3 = Geodesic(EllipsoidWGS84);

//  writeln("OK");

}
unittest{
  import std.stdio;
  import std.math;

  double a = 6378137, f = 1/298.257223563; /* WGS84 */
  double lat1, lon1, azi1, lat2, lon2, azi2, s12;

  lat1 = 54.5;
  lon1 = 18.5;
  lat2 = 55.5;
  lon2 = 17.5;

  auto g1 = Geodesic(a,f);
  auto g_out1 = g1.inverse(lat1, lon1, lat2, lon2);
  double [3] g_out1_test = [128403.130195, -29.483701, -30.302891];

  assert(abs(g_out1[0] - g_out1_test[0]) < 1e-6);
  assert(abs(g_out1[1] - g_out1_test[1]) < 1e-6);
  assert(abs(g_out1[2] - g_out1_test[2]) < 1e-6);

  auto g_out2 = g1.direct(lat1, lon1, 90.0, 50000.0);
  double [3] g_out2_test = [54.497537, 19.271724, 90.628266];

  assert(abs(g_out2[0] - g_out2_test[0]) < 1e-6);
  assert(abs(g_out2[1] - g_out2_test[1]) < 1e-6);
  assert(abs(g_out2[2] - g_out2_test[2]) < 1e-6);

  //writefln("%f, %f, %f ", g_out2[0], g_out2[1],g_out2[2]);
  //auto dd = g1.direct(lat1, lon1, 90.0, 50000.0);
  //writeln(dd);
}

unittest{
  import std.stdio;
  import std.math;

  auto g1 = Geodesic(EllipsoidWGS84);
  auto p1 = LatLon(54.5, 18.5);
  auto p2 = LatLon(55.5, 17.5);
  auto g_out1 = g1.inverse(p1, p2);
  DistAz1Az2 g_out1_test = {128403.130195, -29.483701, -30.302891};
  //writeln(g_out1);
  assert(abs(g_out1.distance - g_out1_test.distance) < 1e-6);
  assert(abs(g_out1.az1 - g_out1_test.az1) < 1e-6);
  assert(abs(g_out1.az2 - g_out1_test.az2) < 1e-6);

  auto g_out2 = g1.direct(p1, AzDist(90.0, 50000.0));
  LatLonAz g_out2_test = {54.497537, 19.271724, 90.628266};
  assert(abs(g_out2.lon - g_out2_test.lon) < 1e-6);
  assert(abs(g_out2.lat - g_out2_test.lat) < 1e-6);
  assert(abs(g_out2.az - g_out2_test.az) < 1e-6);
  //writeln(g_out2);
}
