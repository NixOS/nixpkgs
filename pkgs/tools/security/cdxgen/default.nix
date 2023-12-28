{ lib
, fetchFromGitHub
, buildNpmPackage
}:

buildNpmPackage rec {
  pname = "cdxgen";
  version = "9.10.1";

  src = fetchFromGitHub {
    owner = "AppThreat";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-FkOWkjf/TXjmSOMSTHvf/MhRtuIPFwGwMt1IUJdvKM0=";
  };

  npmDepsHash = "sha256-2DDLogGXT9G8tKJYxVtS7oa5szlaaQTs1kJcgq9GA7k=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Creates CycloneDX Software Bill-of-Materials (SBOM) for your projects from source and container images";
    homepage = "https://github.com/AppThreat/cdxgen";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
