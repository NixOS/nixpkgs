{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "air";
  version = "1.41.0";

  src = fetchFromGitHub {
    owner = "cosmtrek";
    repo = "air";
    rev = "v${version}";
    hash = "sha256-31C1iNiYokClAZlk9KOVE12lFdOKJBSOwQK+zOp082k=";
  };

  vendorHash = "sha256-i3bXf/EsPAJOg2aWh4mANtNeRXnie4jtuLCd/01DB/0=";

   ldflags = [ "-s" "-w" "-X=main.airVersion=${version}" ];

  subPackages = [ "." ];

  meta = with lib; {
    description = "Live reload for Go apps";
    homepage = "https://github.com/cosmtrek/air";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ Gonzih ];
  };
}
