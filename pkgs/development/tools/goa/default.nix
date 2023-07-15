{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "goa";
  version = "3.12.1";

  src = fetchFromGitHub {
    owner = "goadesign";
    repo = "goa";
    rev = "v${version}";
    sha256 = "sha256-cQyBPg+3Sf2ABjRv3n9dVgMvhUpndNPUnOsRS4a+ABw=";
  };
  vendorHash = "sha256-XQyE99o6notsinQv39JbxW0XG3FqlMoDfDJQ72U5GTA=";

  subPackages = [ "cmd/goa" ];

  meta = with lib; {
    description = "Design-based APIs and microservices in Go";
    homepage = "https://goa.design";
    license = licenses.mit;
    maintainers = with maintainers; [ rushmorem ];
  };
}
