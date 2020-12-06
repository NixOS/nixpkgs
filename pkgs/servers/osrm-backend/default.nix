{stdenv, fetchFromGitHub, cmake, pkgconfig, bzip2, libxml2, libzip, boost, lua, luabind, tbb, expat}:

stdenv.mkDerivation rec {
  pname = "osrm-backend";
  version = "5.23.0";

  src = fetchFromGitHub {
    owner  = "Project-OSRM";
    repo   = "osrm-backend";
    rev = "v${version}";
    sha256 = "sha256-FWfrdnpdx4YPa9l7bPc6QNyqyNvrikdeADSZIixX5vE=";
  };

  NIX_CFLAGS_COMPILE = [ "-Wno-error=pessimizing-move" "-Wno-error=redundant-move" ];

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ bzip2 libxml2 libzip boost lua luabind tbb expat ];

  postInstall = "mkdir -p $out/share/osrm-backend && cp -r ../profiles $out/share/osrm-backend/profiles";

  meta = {
    homepage = "https://github.com/Project-OSRM/osrm-backend/wiki";
    description = "Open Source Routing Machine computes shortest paths in a graph. It was designed to run well with map data from the Openstreetmap Project";
    license = stdenv.lib.licenses.bsd2;
    maintainers = with stdenv.lib.maintainers;[ erictapen ];
    platforms = stdenv.lib.platforms.linux;
  };
}
