{ lib
, stdenv
, curl
, fetchFromGitHub
, lz4
, postgresql
}:

stdenv.mkDerivation rec {
  pname = "citus";
  version = "12.1.0";

  src = fetchFromGitHub {
    owner = "citusdata";
    repo = "citus";
    rev = "v${version}";
    hash = "sha256-ypuinDOHvgjRdbnTTFBpALy6rIR3rrP00JDvlHtmCTk=";
  };

  buildInputs = [
    curl
    lz4
    postgresql
  ];

  installPhase = ''
    runHook preInstall

    install -D -t $out/lib src/backend/columnar/citus_columnar${postgresql.dlSuffix}
    install -D -t $out/share/postgresql/extension src/backend/columnar/build/sql/*.sql
    install -D -t $out/share/postgresql/extension src/backend/columnar/*.control

    install -D -t $out/lib src/backend/distributed/citus${postgresql.dlSuffix}
    install -D -t $out/share/postgresql/extension src/backend/distributed/build/sql/*.sql
    install -D -t $out/share/postgresql/extension src/backend/distributed/*.control

    runHook postInstall
  '';

  meta = with lib; {
    # "Our soft policy for Postgres version compatibilty is to support Citus'
    # latest release with Postgres' 3 latest releases."
    # https://www.citusdata.com/updates/v12-0/#deprecated_features
    broken = versionOlder postgresql.version "14";
    description = "Distributed PostgreSQL as an extension";
    homepage = "https://www.citusdata.com/";
    changelog = "https://github.com/citusdata/citus/blob/${src.rev}/CHANGELOG.md";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ marsam ];
    inherit (postgresql.meta) platforms;
  };
}
