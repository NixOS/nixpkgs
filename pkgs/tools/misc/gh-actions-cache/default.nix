{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "gh-actions-cache";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "actions";
    repo = "gh-actions-cache";
    rev = "v${version}";
    hash = "sha256-5iCj6z4HCMVFeplb3dGP/V60z6zMUnUPVBMnPi4yU1Q=";
  };

  vendorHash = "sha256-i9akQ0IjH9NItjYvMWLiGnFQrfZhA7SOvPZiUvdtDrk=";

  ldflags = [
    "-s"
    "-w"
  ];

  # Tests need network
  doCheck = false;

  meta = {
    description = "gh extension to manage GitHub Actions caches";
    homepage = "https://github.com/actions/gh-actions-cache";
    changelog = "https://github.com/actions/gh-actions-cache/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ amesgen ];
  };
}
