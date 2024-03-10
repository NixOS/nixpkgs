{ lib
, fetchFromGitHub
, buildNpmPackage
}:

buildNpmPackage rec {
  pname = "cdxgen";
  version = "10.2.1";

  src = fetchFromGitHub {
    owner = "AppThreat";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-X359aLnC0FAiS3pOBQsjmdik01zjZayTvwBLk3sj8ew=";
  };

  npmDepsHash = "sha256-1vPdKD1Ul+6hq8dYxscL4YLmefnP2zOWRtQWyO6Q0eQ=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Creates CycloneDX Software Bill-of-Materials (SBOM) for your projects from source and container images";
    homepage = "https://github.com/AppThreat/cdxgen";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
