{ lib
, fetchFromGitHub
, buildNpmPackage
}:

buildNpmPackage rec {
  pname = "cdxgen";
  version = "10.0.3";

  src = fetchFromGitHub {
    owner = "AppThreat";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-YdMJPYRXH1OEMYcb7Erl0++bCMu90hlBSEMf5vL1/Ss=";
  };

  npmDepsHash = "sha256-RmAxOQ7fvZXVgcexKWgHUmUd7qhQZ683Wo5pazsCUOU=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Creates CycloneDX Software Bill-of-Materials (SBOM) for your projects from source and container images";
    homepage = "https://github.com/AppThreat/cdxgen";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
