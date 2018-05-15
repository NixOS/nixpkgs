{stdenv, fetchFromGitHub, cmake, pkgconfig, bzip2, libxml2, libzip, boost, lua, luabind, tbb, expat}:

stdenv.mkDerivation rec {
  name = "osrm-backend-${version}";
  version = "5.17.2";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner  = "Project-OSRM";
    repo   = "osrm-backend";
    sha256 = "0ar94wpsc2vr6pn4x5wy7mkpjlilgnyw545wm0l78174q43460y9";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ bzip2 libxml2 libzip boost lua luabind tbb expat ];

  postInstall = "mkdir -p $out/share/osrm-backend && cp -r ../profiles $out/share/osrm-backend/profiles";

  meta = {
    homepage = https://github.com/Project-OSRM/osrm-backend/wiki;
    description = "Open Source Routing Machine computes shortest paths in a graph. It was designed to run well with map data from the Openstreetmap Project";
    license = stdenv.lib.licenses.bsd2;
    maintainers = with stdenv.lib.maintainers;[ erictapen ];
    platforms = stdenv.lib.platforms.linux;
  };
}
