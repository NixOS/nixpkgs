{stdenv, fetchurl, cmake, luabind, libosmpbf, stxxl, tbb, boost, expat, protobuf, bzip2, zlib, substituteAll}:

stdenv.mkDerivation rec {
  name = "osrm-backend-4.5.0";

  src = fetchurl {
    url = "https://github.com/Project-OSRM/osrm-backend/archive/v4.5.0.tar.gz";
    sha256 = "af61e883051f2ecb73520ace6f17cc6da30edc413208ff7cf3d87992eca0756c";
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
