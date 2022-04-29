{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "goreman";
  version = "0.3.11";
  rev = "6006c6e410ec5a5ba22b50e96227754a42f2834d";

  src = fetchFromGitHub {
    owner = "mattn";
    repo = "goreman";
    rev = "v${version}";
    sha256 = "sha256-TbJfeU94wakI2028kDqU+7dRRmqXuqpPeL4XBaA/HPo=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.revision=${builtins.substring 0 7 rev}"
  ];

  vendorSha256 = "sha256-87aHBRWm5Odv6LeshZty5N31sC+vdSwGlTYhk3BZkPo=";

  meta = with lib; {
    description = "foreman clone written in go language";
    homepage = "https://github.com/mattn/goreman";
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
  };
}
