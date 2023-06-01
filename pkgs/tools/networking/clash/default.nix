{ lib
, fetchFromGitHub
, buildGoModule
, testers
, clash
}:

buildGoModule rec {
  pname = "clash";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "Dreamacro";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-y2Z4YaVKKFxZzLUOUs1PeMkWhFimAhu9nAahhX/4Xn8=";
  };

  vendorHash = "sha256-raDqnQQtkyGsop7leH6FDCOY4Yi1u/EsBVl71r3v9l0=";

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
    homepage = "https://dreamacro.github.io/clash/";
    changelog = "https://github.com/Dreamacro/clash/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ contrun Br1ght0ne ];
  };
}
