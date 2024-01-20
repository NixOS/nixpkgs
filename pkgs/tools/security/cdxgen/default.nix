{ lib
, fetchFromGitHub
, buildNpmPackage
}:

buildNpmPackage rec {
  pname = "cdxgen";
  version = "9.11.1";

  src = fetchFromGitHub {
    owner = "AppThreat";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-UrwC6T0XJeEETMtwphLWAnN7grWPI/O4aa3IKrWMhOM=";
  };

  npmDepsHash = "sha256-RbHauQkggFlIoIgDdC7A4Y/O4viTsDWNB2MPeDi8oZc=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Creates CycloneDX Software Bill-of-Materials (SBOM) for your projects from source and container images";
    homepage = "https://github.com/AppThreat/cdxgen";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
