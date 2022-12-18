{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "changie";
  version = "1.10.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "miniscruff";
    repo = pname;
    sha256 = "sha256-c7QEDyxk3Y/niQtVNQiS4OS/nHkldtjEcaXXR7rx/QI=";
  };

  vendorSha256 = "sha256-AoQdOw5Yw54mGmwfozkxtfo3ZhWGUbBoHc3Iqy80x38=";

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
