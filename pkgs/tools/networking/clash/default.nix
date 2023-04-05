{ lib, fetchFromGitHub, buildGoModule, testers, clash }:

buildGoModule rec {
  pname = "clash";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "Dreamacro";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-w/Iz1PZekeKVGFHPteMEbjLP3V9qMmLLAz27qW0VtPk=";
  };

  vendorHash = "sha256-raNFt+Ymh7m+p1wXy1ofMO1UJ2EouwaY7Ysngfw3X8U=";

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
