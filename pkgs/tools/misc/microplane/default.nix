{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "microplane";
  version = "0.0.31";

  src = fetchFromGitHub {
    owner = "Clever";
    repo = "microplane";
    rev = "v${version}";
    sha256 = "sha256-PcojOFe3SHhnFy09kcxHhb5kd07TG7Uq+coPUNbJjx4=";
  };

  vendorSha256 = "sha256-5HHdxSXg3ZIUyFQALaYgvf4pQwNxG58cF4vnCnMgAuY=";

  buildFlagsArray = ''
    -ldflags=-s -w -X main.version=${version}
  '';

  postInstall = ''
    ln -s $out/bin/microplane $out/bin/mp
  '';

  meta = with lib; {
    description = "A CLI tool to make git changes across many repos";
    homepage = "https://github.com/Clever/microplane";
    license = licenses.asl20;
    maintainers = with maintainers; [ dbirks ];
  };
}
