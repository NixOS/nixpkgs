{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "hjson-go";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "hjson";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Ni8sT69+/RsVazmS4Gs9hSxz5oqeLkwCG+mVu7/5ZL8=";
  };

  vendorSha256 = null;

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Utility to convert JSON to and from HJSON";
    homepage = "https://hjson.github.io/";
    maintainers = with maintainers; [ ehmry ];
    license = licenses.mit;
    mainProgram = "hjson-cli";
  };
}
