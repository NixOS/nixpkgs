{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "gh-dash";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "dlvhdr";
    repo = "gh-dash";
    rev = "v${version}";
    sha256 = "sha256-pQd41uQdfkbqIjdUIwUnKS/Qso495Ips8P2CXPd8JRU=";
  };

  vendorHash = "sha256-66GxD48fCWUWMyZ3GiivWNtz0mgI4JHMcvNwHGFTRfU=";

  ldflags = [ "-s" "-w" ];

  meta = {
    description = "gh extension to display a dashboard with pull requests and issues";
    homepage = "https://github.com/dlvhdr/gh-dash";
    changelog = "https://github.com/dlvhdr/gh-dash/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ amesgen ];
  };
}
