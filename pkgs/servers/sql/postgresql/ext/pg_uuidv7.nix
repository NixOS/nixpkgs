{ lib
, stdenv
, fetchFromGitHub
, postgresql
, buildPostgresqlExtension
}:

buildPostgresqlExtension rec {
  pname = "pg_uuidv7";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "fboulnois";
    repo = "pg_uuidv7";
    rev = "v${version}";
    hash = "sha256-oVyRtjl3KsD3j96qvQb8bFLMhoWO81OudOL4wVXrjzI=";
  };

  meta = with lib; {
    description = "Tiny Postgres extension to create version 7 UUIDs";
    homepage = "https://github.com/fboulnois/pg_uuidv7";
    changelog = "https://github.com/fboulnois/pg_uuidv7/blob/main/CHANGELOG.md";
    maintainers = with maintainers; [ gaelreyrol ];
    platforms = postgresql.meta.platforms;
    license = licenses.mpl20;
    broken = versionOlder postgresql.version "13";
  };
}
