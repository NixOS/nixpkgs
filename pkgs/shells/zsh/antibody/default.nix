{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "antibody";
  version = "4.1.1";

  goPackagePath = "github.com/getantibody/antibody";

  src = fetchFromGitHub {
    owner = "getantibody";
    repo = "antibody";
    rev = "v${version}";
    sha256 = "1qfic9prdbldvjw0n15jfc9qr4p5h87mjripq2pc4c6x8244phfw";
  };

  modSha256 = "1p9cw92ivwgpkvjxvwd9anbd1vzhpicm9il4pg37z2kgr2ihhnyh";

  meta = with lib; {
    description = "The fastest shell plugin manager";
    homepage = https://github.com/getantibody/antibody;
    license = licenses.mit;
    maintainers = with maintainers; [ worldofpeace ];
  };
}
