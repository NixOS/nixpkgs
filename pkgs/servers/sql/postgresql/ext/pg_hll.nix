{ lib, stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  pname = "pg_hll";
  version = "2.15.1";

  buildInputs = [ postgresql ];

  src = fetchFromGitHub {
    owner  = "citusdata";
    repo   = "postgresql-hll";
    rev    = "refs/tags/v${version}";
    sha256 = "17lg05rw7299fvfhdzvznr692c21s5qar1wzzvgwfv7afv6xzr3y";
  };

  installPhase = ''
    mkdir -p $out/{lib,share/postgresql/extension}

    cp *.so      $out/lib
    cp *.sql     $out/share/postgresql/extension
    cp *.control $out/share/postgresql/extension
  '';

  meta = with lib; {
    description = "HyperLogLog for PostgreSQL";
    homepage    = "https://github.com/citusdata/postgresql-hll";
    changelog   = "https://github.com/citusdata/postgresql-hll/blob/v${version}/CHANGELOG.md";
    maintainers = with maintainers; [ thoughtpolice ];
    platforms   = postgresql.meta.platforms;
    license     = licenses.asl20;
  };
}
