{lib, stdenv, fetchFromGitHub, cmake, pkg-config, bzip2, libxml2, libzip, boost, lua, luabind, tbb, expat}:

stdenv.mkDerivation rec {
  pname = "osrm-backend";
  version = "5.26.0";

  src = fetchFromGitHub {
    owner  = "Project-OSRM";
    repo   = "osrm-backend";
    rev = "v${version}";
    sha256 = "sha256-kqRYE26aeq7nCen56TJo3BlyLFWn4NMltsq+re64/VQ=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ bzip2 libxml2 libzip boost lua luabind tbb expat ];

  patches = [ ./darwin.patch ];

  env.NIX_CFLAGS_COMPILE = toString [
    # Needed with GCC 12
    "-Wno-error=stringop-overflow"
    "-Wno-error=uninitialized"
  ];

  postInstall = "mkdir -p $out/share/osrm-backend && cp -r ../profiles $out/share/osrm-backend/profiles";

  meta = {
    homepage = "https://github.com/Project-OSRM/osrm-backend/wiki";
    description = "Open Source Routing Machine computes shortest paths in a graph. It was designed to run well with map data from the Openstreetmap Project";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers;[ erictapen ];
    platforms = lib.platforms.unix;
  };
}
