{ lib
, fetchFromGitHub
, buildNpmPackage
}:

buildNpmPackage rec {
  pname = "cdxgen";
  version = "10.4.3";

  src = fetchFromGitHub {
    owner = "AppThreat";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-m6AtAbsZ7zPu7MlwEt9+RBs11DAHNa3x0Nn7b3TWdAY=";
  };

  npmDepsHash = "sha256-z7tBghs2bg2eYNRkhe9J8/0rqaAXV5e5ZT9u5fdABe0=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Creates CycloneDX Software Bill-of-Materials (SBOM) for your projects from source and container images";
    homepage = "https://github.com/AppThreat/cdxgen";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
