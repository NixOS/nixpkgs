{ lib
, fetchFromGitHub
, buildGoModule
, testers
, clash
}:

buildGoModule rec {
  pname = "clash";
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "Dreamacro";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-hUkUfNsThir0txO7cdxJl3sUF8/wHDvDPVspGp5xYUQ=";
  };

  vendorHash = "sha256-M2hoorCBdq2nm5Gc5Xm6r7Cg9XUOirDyqTKwrmu121s=";

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
