{ fetchFromBitbucket, stdenv }:

stdenv.mkDerivation rec {
  name = "pg_tmp-${version}";
  version = "2.3";

  src = fetchFromBitbucket {
    owner = "eradman";
    repo = "ephemeralpg";
    rev = "ephemeralpg-${version}";
    sha256 = "0j0va9pch2xhwwx4li3qx3lkgrd79c0hcy5w5y1cqax571hv89wa";
  };

  installPhase = ''
    PREFIX=$out make install
  '';

  meta = with stdenv.lib; {
    homepage = http://ephemeralpg.org;
    description = "Run tests on an isolated, temporary PostgreSQL database";
    license = licenses.isc;
    platforms = platforms.all;
    maintainers = with maintainers; [ hrdinka ];
  };
}
