{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "goa";
  version = "3.15.2";

  src = fetchFromGitHub {
    owner = "goadesign";
    repo = "goa";
    rev = "v${version}";
    hash = "sha256-jzhvElHOBzekW3cyXf7wJG+8E1GObWVtPbBw18/dpCk=";
  };
  vendorHash = "sha256-Z31hTOMmxFM0zmHoZRJaIz7ka2adV0crdhou6EudDWw=";

  subPackages = [ "cmd/goa" ];

  meta = with lib; {
    description = "Design-based APIs and microservices in Go";
    mainProgram = "goa";
    homepage = "https://goa.design";
    license = licenses.mit;
    maintainers = with maintainers; [ rushmorem ];
  };
}
