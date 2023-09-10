{ lib
, fetchFromGitHub
, buildGoModule
, testers
, clash
}:

buildGoModule rec {
  pname = "clash";
  version = "1.18.0";

  src = fetchFromGitHub {
    owner = "Dreamacro";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-LqjSPlPkR5sB4Z1pmpdE9r66NN7pwgE9GK4r1zSFlxs=";
  };

  vendorHash = "sha256-EWAbEFYr15RiJk9IXF6KaaX4GaSCa6E4+8rKL4/XG8Y=";

  # Do not build testing suit
  excludedPackages = [ "./test" ];

  CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/Dreamacro/clash/constant.Version=${version}"
  ];

  checkFlags = [
    "-skip=TestParseRule" # Flaky tests
  ];

  passthru.tests.version = testers.testVersion {
    package = clash;
    command = "clash -v";
  };

  meta = with lib; {
    description = "A rule-based tunnel in Go";
    homepage = "https://dreamacro.github.io/clash/";
    changelog = "https://github.com/Dreamacro/clash/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ contrun Br1ght0ne ];
    mainProgram = "clash";
  };
}
