{ lib
, stdenv
, curl
, fetchFromGitHub
, lz4
, postgresql
, buildPostgresqlExtension
}:

buildPostgresqlExtension rec {
  pname = "citus";
  version = "12.1.2";

  src = fetchFromGitHub {
    owner = "citusdata";
    repo = "citus";
    rev = "v${version}";
    hash = "sha256-0uYNMLAYigtGlDRvOEkQeC5i58QfXcdSVjTQwWVFX+8=";
  };

  buildInputs = [
    curl
    lz4
  ];

  meta = with lib; {
    # "Our soft policy for Postgres version compatibility is to support Citus'
    # latest release with Postgres' 3 latest releases."
    # https://www.citusdata.com/updates/v12-0/#deprecated_features
    broken = versionOlder postgresql.version "14" ||
      # PostgreSQL 17 support issue upstream: https://github.com/citusdata/citus/issues/7708
      # Check after next package update.
      (versionAtLeast postgresql.version "17" && version == "12.1.2");
    description = "Distributed PostgreSQL as an extension";
    homepage = "https://www.citusdata.com/";
    changelog = "https://github.com/citusdata/citus/blob/${src.rev}/CHANGELOG.md";
    license = licenses.agpl3Only;
    maintainers = [ ];
    inherit (postgresql.meta) platforms;
  };
}
