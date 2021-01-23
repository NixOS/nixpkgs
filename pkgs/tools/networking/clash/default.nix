{ lib, stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "clash";
  version = "1.3.5";

  src = fetchFromGitHub {
    owner = "Dreamacro";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-yTkUGsVwK6nwHUQpYhkPYF/Cf4URrr5ThB67sxq7Ecs=";
  };

  vendorSha256 = "sha256-J7VGYxX1bH5CeDhpqK9mIbHUekXslImZ+O3wN5Q7kYk=";

  doCheck = false;

  buildFlagsArray = [
    "-ldflags="
    "-X github.com/Dreamacro/clash/constant.Version=${version}"
  ];

  meta = with lib; {
    description = "A rule-based tunnel in Go";
    homepage = "https://github.com/Dreamacro/clash";
    license = licenses.gpl3;
    maintainers = with maintainers; [ contrun Br1ght0ne ];
  };
}
