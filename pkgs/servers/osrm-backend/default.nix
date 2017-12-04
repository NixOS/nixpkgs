{stdenv, fetchFromGitHub, cmake, luabind, libosmpbf, stxxl, tbb, boost, expat, protobuf, bzip2, zlib, substituteAll}:

stdenv.mkDerivation rec {
  name = "osrm-backend-${version}";
  version = "5.12.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner  = "Project-OSRM";
    repo   = "osrm-backend";
    sha256 = "1ix18r1fylnawhk5rykimrx1sryww7qv59idldmxydzwdam0nb2z";
  };

  buildInputs = [ cmake luabind libosmpbf stxxl tbb boost expat protobuf bzip2 zlib ];

  postInstall = "mkdir -p $out/share/osrm-backend && cp -r ../profiles $out/share/osrm-backend/profiles";

  meta = {
    homepage = https://github.com/Project-OSRM/osrm-backend/wiki;
    description = "Open Source Routing Machine computes shortest paths in a graph. It was designed to run well with map data from the Openstreetmap Project";
    license = stdenv.lib.licenses.bsd2;
    platforms = stdenv.lib.platforms.linux;
  };
}
