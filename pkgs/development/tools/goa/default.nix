{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "goa";
  version = "3.17.1";

  src = fetchFromGitHub {
    owner = "goadesign";
    repo = "goa";
    rev = "v${version}";
    hash = "sha256-7oUQLY2wb9+YPgVk7r9/N/5b9ytW6eJT5XV+pjzknDA=";
  };
  vendorHash = "sha256-BRZSGEpIPgFlIAj01fXd7EyUqm7X0tCDCoAArRyeduA=";

  subPackages = [ "cmd/goa" ];

  meta = with lib; {
    description = "Design-based APIs and microservices in Go";
    mainProgram = "goa";
    homepage = "https://goa.design";
    license = licenses.mit;
    maintainers = with maintainers; [ rushmorem ];
  };
}
