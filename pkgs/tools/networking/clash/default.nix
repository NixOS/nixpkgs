{ lib, fetchFromGitHub, buildGoModule, testers, clash }:

buildGoModule rec {
  pname = "clash";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "Dreamacro";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-f/iSnSaRr1dqMRKb7GDZdc2WuykO42XMSNKwMOwuagc=";
  };

  vendorHash = "sha256-fDn6UlijI2TJPF4FS50u1MMDxnd8eDTbqHLnGso/FoU=";

  # Do not build testing suit
  excludedPackages = [ "./test" ];

  CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/Dreamacro/clash/constant.Version=${version}"
  ];

  passthru.tests.version = testers.testVersion {
    package = clash;
    command = "clash -v";
  };

  meta = with lib; {
    description = "A rule-based tunnel in Go";
    homepage = "https://github.com/Dreamacro/clash";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ contrun Br1ght0ne ];
  };
}
