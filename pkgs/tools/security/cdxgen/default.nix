{ lib
, fetchFromGitHub
, buildNpmPackage
}:

buildNpmPackage rec {
  pname = "cdxgen";
  version = "9.10.2";

  src = fetchFromGitHub {
    owner = "AppThreat";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-d4abSPP0dLi5xzq1CYxi1MSKogrQ+YcZjmlUEr5+oBQ=";
  };

  npmDepsHash = "sha256-KLI6wJrP2s2UWkSC5zmFuC2sa2owRgAhnR4UVrI0ThY=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Creates CycloneDX Software Bill-of-Materials (SBOM) for your projects from source and container images";
    homepage = "https://github.com/AppThreat/cdxgen";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
