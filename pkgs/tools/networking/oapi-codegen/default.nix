{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "oapi-codegen";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "deepmap";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-xanS2oPh+f+cmiTrfbMvFKcFVQ5DsWDe3KOZzhOl370=";
  };

  vendorHash = "sha256-8qjS0BdBwnRjs3GrWHZOnxIJCiiGzgX2mqlmWLWzDuA=";

  # Tests use network
  doCheck = false;

  meta = with lib; {
    description = "Go client and server OpenAPI 3 generator";
    homepage = "https://github.com/deepmap/oapi-codegen";
    changelog = "https://github.com/deepmap/oapi-codegen/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ j4m3s ];
  };
}
