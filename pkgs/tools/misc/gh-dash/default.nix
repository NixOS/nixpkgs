{ lib
, fetchFromGitHub
, buildGoModule
, testers
, gh-dash
}:

buildGoModule rec {
  pname = "gh-dash";
  version = "3.14.0";

  src = fetchFromGitHub {
    owner = "dlvhdr";
    repo = "gh-dash";
    rev = "v${version}";
    hash = "sha256-6YPUGOQ2KBfu+3XAgub9Cpz0QBrU2kV+gq13tUtzY+w=";
  };

  vendorHash = "sha256-jCf9FWAhZK5hTzyy8N4r5dfUYTgESmsn8iKxCccgWiM=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/dlvhdr/gh-dash/cmd.Version=${version}"
  ];

  passthru.tests = {
    version = testers.testVersion { package = gh-dash; };
  };

  meta = {
    changelog = "https://github.com/dlvhdr/gh-dash/releases/tag/${src.rev}";
    description = "Github Cli extension to display a dashboard with pull requests and issues";
    homepage = "https://github.com/dlvhdr/gh-dash";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ amesgen ];
    mainProgram = "gh-dash";
  };
}
