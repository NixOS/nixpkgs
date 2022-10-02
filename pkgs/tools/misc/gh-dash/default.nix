{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "gh-dash";
  version = "3.4.1";

  src = fetchFromGitHub {
    owner = "dlvhdr";
    repo = "gh-dash";
    rev = "v${version}";
    sha256 = "sha256-NGUuUBCoLKyyFdTw7n/PY486JEcrTsed4/iuB9iUTLE=";
  };

  vendorSha256 = "sha256-BbrHvphTQLvUKanmO4GrNpkT0MSlY7+WMJiyXV7dFB8=";

  ldflags = [ "-s" "-w" ];

  meta = {
    description = "gh extension to display a dashboard with pull requests and issues";
    homepage = "https://github.com/dlvhdr/gh-dash";
    changelog = "https://github.com/dlvhdr/gh-dash/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ amesgen ];
  };
}
