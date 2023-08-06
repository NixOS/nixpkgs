{ lib
, fetchFromGitHub
, buildGoModule
, testers
, gh-dash
}:

buildGoModule rec {
  pname = "gh-dash";
  version = "3.10.0";

  src = fetchFromGitHub {
    owner = "dlvhdr";
    repo = "gh-dash";
    rev = "v${version}";
    hash = "sha256-ypYM/FXp+BObR2fjVCV8nDJhRuuu2Y7213haAJnzRIE=";
  };

  vendorHash = "sha256-lOIONv+7cUUC0mGCwYkOkDn3zHreYpFeqmTbp2Ob3yM=";

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
  };
}
