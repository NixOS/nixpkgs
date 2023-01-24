{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gops";
  version = "0.3.25";

  src = fetchFromGitHub {
    owner = "google";
    repo = "gops";
    rev = "v${version}";
    sha256 = "sha256-y2T+v4EafiVuyRiuQdNDECc06e5eHtquvGA9ugW55Bs=";
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
