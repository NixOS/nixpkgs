{ lib
, fetchFromGitHub
, buildNpmPackage
}:

buildNpmPackage rec {
  pname = "cdxgen";
  version = "10.2.4";

  src = fetchFromGitHub {
    owner = "AppThreat";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fou0BfQfL66Iv+STY0JcRqu22XTgA9nSOse1LJYl3vs=";
  };

  npmDepsHash = "sha256-ISmNasK44T21HagHKrX1LyCFVm0GF0CsTwIIi3n8h2o=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Creates CycloneDX Software Bill-of-Materials (SBOM) for your projects from source and container images";
    homepage = "https://github.com/AppThreat/cdxgen";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
