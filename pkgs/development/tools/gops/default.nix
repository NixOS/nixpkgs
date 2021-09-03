{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gops";
  version = "0.3.19";

  src = fetchFromGitHub {
    owner = "google";
    repo = "gops";
    rev = "v${version}";
    sha256 = "sha256-9QEhc0OVCrIdIY220PDn2+CjUsCF84l6QRQS0HjDEZY=";
  };

  vendorSha256 = null;

  preCheck = "export HOME=$(mktemp -d)";

  meta = with lib; {
    description = "A tool to list and diagnose Go processes currently running on your system";
    homepage = "https://github.com/google/gops";
    license = licenses.bsd3;
    maintainers = with maintainers; [ pborzenkov ];
  };
}
