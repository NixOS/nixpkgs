{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "gh-dash";
  version = "3.5.1";

  src = fetchFromGitHub {
    owner = "dlvhdr";
    repo = "gh-dash";
    rev = "v${version}";
    sha256 = "sha256-MGdo145qdm/uOiVJfuxy1vblgJjPGQWf3i58xpAWIkQ=";
  };

  vendorSha256 = "sha256-66GxD48fCWUWMyZ3GiivWNtz0mgI4JHMcvNwHGFTRfU=";

  ldflags = [ "-s" "-w" ];

  meta = {
    description = "gh extension to display a dashboard with pull requests and issues";
    homepage = "https://github.com/dlvhdr/gh-dash";
    changelog = "https://github.com/dlvhdr/gh-dash/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ amesgen ];
  };
}
