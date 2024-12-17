{
  lib,
  stdenv,
  fetchFromGitHub,
  postgresql,
  buildPostgresqlExtension,
}:

buildPostgresqlExtension {
  pname = "tsearch-extras";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "zulip";
    repo = "tsearch_extras";
    rev = "84e78f00931c4ef261d98197d6b5d94fc141f742"; # no release tag?
    sha256 = "18j0saqblg3jhrz38splk173xjwdf32c67ymm18m8n5y94h8d2ba";
  };

  meta = with lib; {
    description = "Provides a few PostgreSQL functions for a lower-level data full text search";
    homepage = "https://github.com/zulip/tsearch_extras/";
    license = licenses.postgresql;
    platforms = postgresql.meta.platforms;
    maintainers = with maintainers; [ DerTim1 ];
  };
}
