{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "changie";
  version = "1.11.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "miniscruff";
    repo = pname;
    sha256 = "sha256-hnRK9pj5NruSRvo2oetyRMVwhO7T/wSEZjcbYHb7ZUY=";
  };

  vendorSha256 = "sha256-0/3Ou8z6yLWhc81hdN2gkaFLLlKQWUGcIdvRHVLTrjQ=";

  ldflags = [ "-s" "-w" "-X=main.version=${version}" ];

  meta = with lib; {
    homepage = "https://changie.dev";
    changelog = "https://github.com/miniscruff/changie/blob/v${version}/CHANGELOG.md";
    description = "Automated changelog tool for preparing releases with lots of customization options";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
  };
}
