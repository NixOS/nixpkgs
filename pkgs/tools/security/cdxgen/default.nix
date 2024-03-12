{ lib
, fetchFromGitHub
, buildNpmPackage
}:

buildNpmPackage rec {
  pname = "cdxgen";
  version = "10.2.2";

  src = fetchFromGitHub {
    owner = "AppThreat";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-N0vz2IaXd0cQBPcmGIdN7Z5IbPyrzSn4+enhFTe0dhI=";
  };

  npmDepsHash = "sha256-2JmrlKoE6iLlw8jsqi2m34npB/GJjBdvoBssAPKVvxA=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Creates CycloneDX Software Bill-of-Materials (SBOM) for your projects from source and container images";
    homepage = "https://github.com/AppThreat/cdxgen";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
