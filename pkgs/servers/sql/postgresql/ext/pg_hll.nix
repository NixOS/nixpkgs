{ stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  name = "pg_hll-${version}";
  version = "2.10.2-${builtins.substring 0 7 src.rev}";

  buildInputs = [ postgresql ];

  src = fetchFromGitHub {
    owner  = "citusdata";
    repo   = "postgresql-hll";
    rev    = "9af41684d479a3097bab87d04936702c9e6baf5c";
    sha256 = "044x9v9kjhxb0idqb9f5i7c3yygxxsqliswl4kspqy9f9qcblckl";
  };

  installPhase = ''
    mkdir -p $out/{lib,share/extension}

    cp *.so      $out/lib
    cp *.sql     $out/share/extension
    cp *.control $out/share/extension
  '';

  passthru = {
    versionCheck = postgresql.compareVersion "11" < 0;
  };

  meta = with stdenv.lib; {
    description = "HyperLogLog for PostgreSQL";
    homepage    = https://www.citusdata.com/;
    maintainers = with maintainers; [ thoughtpolice ];
    platforms   = platforms.linux;
    license     = licenses.asl20;
  };
}
