{stdenv, fetchFromGitHub, cmake, luabind, libosmpbf, stxxl, tbb, boost, expat, protobuf, bzip2, zlib, substituteAll}:

stdenv.mkDerivation rec {
  name = "osrm-backend-4.5.0";

  src = fetchFromGitHub {
    rev = "v4.5.0";
    owner  = "Project-OSRM";
    repo   = "osrm-backend";
    sha256 = "19a8d1llvsrysyk1q48dpmh75qcbibfjlszndrysk11yh62hdvsz";
  };

  patches = [
    ./4.5.0-openmp.patch
    ./4.5.0-gcc-binutils.patch
    (substituteAll {
      src = ./4.5.0-default-profile-path.template.patch;
    })
  ];

  buildInputs = [ cmake luabind libosmpbf stxxl tbb boost expat protobuf bzip2 zlib ];

  postInstall = "mkdir -p $out/share/osrm-backend && cp -r ../profiles $out/share/osrm-backend/profiles";

  meta = {
    homepage = https://github.com/Project-OSRM/osrm-backend/wiki;
    description = "Open Source Routing Machine computes shortest paths in a graph. It was designed to run well with map data from the Openstreetmap Project";
    license = stdenv.lib.licenses.bsd2;
  };
}
