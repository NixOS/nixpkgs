{
  stdenv,
  fetchFromGitHub,
  lib,
  postgresql,
  buildPostgresqlExtension,
}:

buildPostgresqlExtension rec {
  pname = "pg_rational";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "begriffs";
    repo = "pg_rational";
    rev = "v${version}";
    sha256 = "sha256-Sp5wuX2nP3KGyWw7MFa11rI1CPIKIWBt8nvBSsASIEw=";
  };

  meta = with lib; {
    description = "Precise fractional arithmetic for PostgreSQL";
    homepage = "https://github.com/begriffs/pg_rational";
    maintainers = with maintainers; [ netcrns ];
    platforms = postgresql.meta.platforms;
    license = licenses.mit;
  };
}
