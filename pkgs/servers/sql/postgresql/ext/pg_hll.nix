{ lib, stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  pname = "pg_hll";
  version = "2.18";

  buildInputs = [ postgresql ];

  src = fetchFromGitHub {
    owner  = "citusdata";
    repo   = "postgresql-hll";
    rev    = "refs/tags/v${version}";
    hash   = "sha256-Latdxph1Ura8yKEokEjalJ+/GY+pAKOT3GXjuLprj6c=";
  };

  installPhase = ''
    install -D -t $out/lib hll${postgresql.dlSuffix}
    install -D -t $out/share/postgresql/extension *.sql
    install -D -t $out/share/postgresql/extension *.control
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
