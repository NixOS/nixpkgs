{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "air";
  version = "1.52.1";

  src = fetchFromGitHub {
    owner = "air-verse";
    repo = "air";
    rev = "v${version}";
    hash = "sha256-KTutLvcLH1dOsJFDaEU2c4wGbQyRE7qUHah4mEXCL08=";
  };

  vendorHash = "sha256-dSu00NAq6hEOdJxXp+12UaUq32z53Wzla3/u+2nxqPw=";

   ldflags = [ "-s" "-w" "-X=main.airVersion=${version}" ];

  subPackages = [ "." ];

  meta = with lib; {
    description = "Live reload for Go apps";
    mainProgram = "air";
    homepage = "https://github.com/air-verse/air";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ Gonzih ];
  };
}
