{ lib
, fetchFromGitHub
, buildNpmPackage
}:

buildNpmPackage rec {
  pname = "cdxgen";
  version = "10.2.3";

  src = fetchFromGitHub {
    owner = "AppThreat";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-C/XTMOFLW2FPPi1Pgx7g5H8jtJlya5LnKmo3oF21yMI=";
  };

  npmDepsHash = "sha256-64dKqV17WvuHjF+n1vCEfpLx6UBNpGkVE+XYi7YswgI=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Creates CycloneDX Software Bill-of-Materials (SBOM) for your projects from source and container images";
    homepage = "https://github.com/AppThreat/cdxgen";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
