{ lib
, fetchFromGitHub
, buildGoModule
, testers
, gh-dash
}:

buildGoModule rec {
  pname = "gh-dash";
  version = "3.11.1";

  src = fetchFromGitHub {
    owner = "dlvhdr";
    repo = "gh-dash";
    rev = "v${version}";
    hash = "sha256-07tp8kfmK/YXfV0Yi4Z27BBAefbdJ0gj2ySq2xDB1nw=";
  };

  vendorHash = "sha256-33W2xd/T1g65eujTTr0q3gYn9np2iELWBEDAjcefwQc=";

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
