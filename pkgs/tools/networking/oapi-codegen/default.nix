{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "oapi-codegen";
  version = "1.13.4";

  src = fetchFromGitHub {
    owner = "deepmap";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-9uHgc2q3ZNM0hQsAY+1RLAH3NfcV+dQo+WRk4OQ8q4Q=";
  };

  vendorHash = "sha256-VsZcdbOGRbHfjKPU+Y01xZCBq4fiVi7qoRBY9AqS0PM=";

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
