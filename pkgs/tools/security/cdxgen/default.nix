{ lib
, fetchFromGitHub
, buildNpmPackage
}:

buildNpmPackage rec {
  pname = "cdxgen";
  version = "10.0.4";

  src = fetchFromGitHub {
    owner = "AppThreat";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-P4F1nCMWvzy65iOYVs7AkC93cftN1Z/BSFsJxOEcQp4=";
  };

  npmDepsHash = "sha256-9T6Dm8IxL8LB8Qx1wRaog6ZDRF6xYO+GteTrhjjxtns=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Creates CycloneDX Software Bill-of-Materials (SBOM) for your projects from source and container images";
    homepage = "https://github.com/AppThreat/cdxgen";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
