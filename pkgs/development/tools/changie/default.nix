{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "changie";
  version = "1.10.2";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "miniscruff";
    repo = pname;
    sha256 = "sha256-1UUF82sYzZDzlhPD8R8QIfR/Vm/9uUAxHzai+A1FCaQ=";
  };

  vendorSha256 = "sha256-oz327wlTrFCj8Hf1wPiND40Ew4kBB/k5doj1us8lhm4=";

  patches = [ ./skip-flaky-test.patch ];

  ldflags = [ "-s" "-w" "-X=main.version=${version}" ];

  meta = with lib; {
    homepage = "https://changie.dev";
    changelog = "https://github.com/miniscruff/changie/blob/v${version}/CHANGELOG.md";
    description = "Automated changelog tool for preparing releases with lots of customization options";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
  };
}
