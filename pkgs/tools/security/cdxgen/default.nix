{ lib
, fetchFromGitHub
, buildNpmPackage
}:

buildNpmPackage rec {
  pname = "cdxgen";
  version = "6.0.14";

  src = fetchFromGitHub {
    owner = "AppThreat";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ddeX2EwA2g6wgfsNxf/5ZVsQOHlINGhxif/y6368wCw=";
  };

  npmDepsHash = "sha256-CJ939wT9dKUzMDH2yHKgT056F2AVBevJlS/NhUBjx0E=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Creates CycloneDX Software Bill-of-Materials (SBOM) for your projects from source and container images";
    homepage = "https://github.com/AppThreat/cdxgen";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
