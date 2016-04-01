{stdenv, fetchFromGitHub, cmake, luabind, libosmpbf, stxxl, tbb, boost, expat, protobuf, bzip2, zlib, substituteAll}:

stdenv.mkDerivation rec {
  name = "osrm-backend-${version}";
  version = "4.9.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner  = "Project-OSRM";
    repo   = "osrm-backend";
    sha256 = "1r4dwniwxgfppnb9asdh98w5qxqwkjhp9gc5fabmck0gk73cwkcc";
  };

  patches = [
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
