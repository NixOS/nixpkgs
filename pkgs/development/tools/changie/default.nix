{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "changie";
  version = "1.10.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "miniscruff";
    repo = pname;
    sha256 = "sha256-8wcnbmS3T/rPKEN3zpo9ysaEIjgbPN50Jp9URpkRaUI=";
  };

  vendorSha256 = "sha256-Ddw4YnOFURZxwqRBX9e1YGMO9E3hUNAoLTVcSJuaCU0=";

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
