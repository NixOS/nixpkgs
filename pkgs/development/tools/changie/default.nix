{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "changie";
  version = "1.9.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "miniscruff";
    repo = pname;
    sha256 = "sha256-3AGz84z0YmDiLxlbDO0f9ny75hyLB4fnYQSICElJVK4=";
  };

  vendorSha256 = "sha256-9Cpyemq/f62rVMvGwOtgDGd9XllvICXL2dqNwUoFQmg=";

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
