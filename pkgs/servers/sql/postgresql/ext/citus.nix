{
  buildPostgresqlExtension,
  curl,
  fetchFromGitHub,
  lib,
  lz4,
  postgresql,
  stdenv,
}:

buildPostgresqlExtension rec {
  pname = "citus";
  version = "13.0.2";

  src = fetchFromGitHub {
    owner = "citusdata";
    repo = "citus";
    tag = "v${version}";
    hash = "sha256-SuJs6OCHKO7efQagsATgn/V9rgMyuXQIHGCEP9ME7tQ=";
  };

  buildInputs = [
    curl
    lz4
  ];

  meta = {
    # "Our soft policy for Postgres version compatibility is to support Citus'
    # latest release with Postgres' 3 latest releases."
    # https://www.citusdata.com/updates/v12-0/#deprecated_features
    broken = lib.versionOlder postgresql.version "15";
    description = "Distributed PostgreSQL as an extension";
    homepage = "https://www.citusdata.com/";
    changelog = "https://github.com/citusdata/citus/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = [ ];
    inherit (postgresql.meta) platforms;
  };
}
