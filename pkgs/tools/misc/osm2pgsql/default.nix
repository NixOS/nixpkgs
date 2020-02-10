{ stdenv, fetchFromGitHub, cmake, expat, proj, bzip2, zlib, boost, postgresql
, withLuaJIT ? false, lua, luajit }:

stdenv.mkDerivation rec {
  pname = "osm2pgsql";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "openstreetmap";
    repo = pname;
    rev = version;
    sha256 = "1ysan01lpqzjxlq3y2kdminfjs5d9zksicpf9vvzpdk3fzq51fc9";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ expat proj bzip2 zlib boost postgresql ]
    ++ stdenv.lib.optional withLuaJIT luajit
    ++ stdenv.lib.optional (!withLuaJIT) lua;

  cmakeFlags = stdenv.lib.optional withLuaJIT "-DWITH_LUAJIT:BOOL=ON";

  NIX_CFLAGS_COMPILE = "-DACCEPT_USE_OF_DEPRECATED_PROJ_API_H";

  meta = with stdenv.lib; {
    description = "OpenStreetMap data to PostgreSQL converter";
    homepage = "https://github.com/openstreetmap/osm2pgsql";
    license = licenses.gpl2;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ jglukasik ];
  };
}
