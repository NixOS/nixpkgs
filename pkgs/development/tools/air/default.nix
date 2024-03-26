{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "air";
  version = "1.51.0";

  src = fetchFromGitHub {
    owner = "cosmtrek";
    repo = "air";
    rev = "v${version}";
    hash = "sha256-Vkg3QPUvhJphmZ7Ek3tuFnSEjfSy6LfctGMA07IufUU=";
  };

  vendorHash = "sha256-dSu00NAq6hEOdJxXp+12UaUq32z53Wzla3/u+2nxqPw=";

   ldflags = [ "-s" "-w" "-X=main.airVersion=${version}" ];

  subPackages = [ "." ];

  meta = with lib; {
    description = "Live reload for Go apps";
    mainProgram = "air";
    homepage = "https://github.com/cosmtrek/air";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ Gonzih ];
  };
}
