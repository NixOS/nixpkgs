{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "clash";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "Dreamacro";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-I4qpcHsN8WGt7YLNXO08BJypilhMSVmZjqECDjlEqXU=";
  };

  vendorSha256 = "sha256-Nfzk7p52msGxTPDbs4g9KuRPFxp4Npt0QXkdVOZvipc=";

  doCheck = false;

  buildFlagsArray = [
    "-ldflags="
    "-X github.com/Dreamacro/clash/constant.Version=${version}"
  ];

  meta = with lib; {
    description = "A rule-based tunnel in Go";
    homepage = "https://github.com/Dreamacro/clash";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ contrun Br1ght0ne ];
  };
}
