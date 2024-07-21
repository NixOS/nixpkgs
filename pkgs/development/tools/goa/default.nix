{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "goa";
  version = "3.17.2";

  src = fetchFromGitHub {
    owner = "goadesign";
    repo = "goa";
    rev = "v${version}";
    hash = "sha256-1ONgo7l2zHOyCFKa13R2zxUiD16aEQQTKVJex+P9fUM=";
  };
  vendorHash = "sha256-2aAOM8v2LOZOBfCjnUGN3frJloabmj5fBMpZxMHVFmk=";

  subPackages = [ "cmd/goa" ];

  meta = with lib; {
    description = "Design-based APIs and microservices in Go";
    mainProgram = "goa";
    homepage = "https://goa.design";
    license = licenses.mit;
    maintainers = with maintainers; [ rushmorem ];
  };
}
