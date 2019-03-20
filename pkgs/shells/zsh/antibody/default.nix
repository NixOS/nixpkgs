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

  modSha256 = "017ybvyfk9bhmp8xwn484gmz4dl03gllv780ssi2arpmcyrwlymw";

  meta = with lib; {
    description = "The fastest shell plugin manager";
    homepage = https://github.com/getantibody/antibody;
    license = licenses.mit;
    maintainers = with maintainers; [ worldofpeace ];
  };
}
