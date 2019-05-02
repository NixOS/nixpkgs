{ stdenv, fetchFromGitHub, postgresql, perl, cmake, boost, gmp, cgal, mpfr }:

stdenv.mkDerivation rec {
  pname = "pgrouting";
  version = "2.6.2";

  nativeBuildInputs = [ cmake perl ];
  buildInputs = [ postgresql boost gmp cgal mpfr ];

  src = fetchFromGitHub {
    owner  = "pgRouting";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "09xy5pmiwq0lxf2m8p4q5r892mfmn32vf8m75p84jnz4707z1l0j";
  };

  installPhase = ''
    mkdir -p $out/bin # for buildEnv, see https://github.com/NixOS/nixpkgs/issues/22653
    install -D lib/*.so                        -t $out/lib
    install -D sql/pgrouting--${version}.sql   -t $out/share/extension
    install -D sql/common/pgrouting.control    -t $out/share/extension
  '';

  meta = with stdenv.lib; {
    description = "A PostgreSQL/PostGIS extension that provides geospatial routing functionality";
    homepage    = https://pgrouting.org/;
    maintainers = [ maintainers.steve-chavez ];
    platforms   = platforms.linux;
    license     = licenses.gpl2;
  };
}
