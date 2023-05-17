{ lib
, fetchFromGitHub
, buildGoModule
, testers
, gh-dash
}:

buildGoModule rec {
  pname = "gh-dash";
  version = "3.7.9";

  src = fetchFromGitHub {
    owner = "dlvhdr";
    repo = "gh-dash";
    rev = "v${version}";
    hash = "sha256-loAtRXns7plBeVOM+d/euyRS86MG+NRhGB4WpHT7KlM=";
  };

  vendorHash = "sha256-0ySTcQDM7Dole6ojnhr7vwUWOM4p6kFN69VqMP0jAY0=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/dlvhdr/gh-dash/cmd.Version=${version}"
  ];

  passthru.tests = {
    version = testers.testVersion { package = gh-dash; };
  };

  meta = {
    description = "gh extension to display a dashboard with pull requests and issues";
    homepage = "https://github.com/dlvhdr/gh-dash";
    changelog = "https://github.com/dlvhdr/gh-dash/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ amesgen ];
  };
}
