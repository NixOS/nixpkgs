{ lib, stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  pname = "pg_cron";
  version = "1.6.2";

  buildInputs = [ postgresql ];

  src = fetchFromGitHub {
    owner  = "citusdata";
    repo   = pname;
    rev    = "v${version}";
    hash   = "sha256-/dD1gX0+RRsBFIjSV9TVk+ppPw0Jrzssl+rRZ2qAp4w=";
  };

  installPhase = ''
    mkdir -p $out/{lib,share/postgresql/extension}

    cp *${postgresql.dlSuffix} $out/lib
    cp *.sql     $out/share/postgresql/extension
    cp *.control $out/share/postgresql/extension
  '';

  meta = with lib; {
    description = "Run Cron jobs through PostgreSQL";
    homepage    = "https://github.com/citusdata/pg_cron";
    changelog   = "https://github.com/citusdata/pg_cron/raw/v${version}/CHANGELOG.md";
    maintainers = with maintainers; [ thoughtpolice ];
    platforms   = postgresql.meta.platforms;
    license     = licenses.postgresql;
  };
}
