{ lib, fetchFromGitHub, buildGoModule, testers, clash }:

buildGoModule rec {
  pname = "clash";
  version = "1.11.4";

  src = fetchFromGitHub {
    owner = "Dreamacro";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-NLGX72eZCfyh6y3mud/btMh15rNXnss7S0P7ujCX1ms=";
  };

  vendorSha256 = "sha256-zaWN/zI4WhHnEK12k1tWZ/qjLGvaZbJ4WfEvCZJ0+ms=";

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
