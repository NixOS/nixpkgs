{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "goa";
  version = "3.14.4";

  src = fetchFromGitHub {
    owner = "goadesign";
    repo = "goa";
    rev = "v${version}";
    hash = "sha256-BwXO03q/vG6DWon0jhGNYckF8DHzaN9RtrX452VC6ls=";
  };
  vendorHash = "sha256-z4oXiGEcXKZTS57p/3gHhCCUDKh/imNu2n5e6+6BjKg=";

  subPackages = [ "cmd/goa" ];

  meta = with lib; {
    description = "Design-based APIs and microservices in Go";
    homepage = "https://goa.design";
    license = licenses.mit;
    maintainers = with maintainers; [ rushmorem ];
  };
}
