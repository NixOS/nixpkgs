{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "circleci-cli";
  version = "0.1.20397";

  src = fetchFromGitHub {
    owner = "CircleCI-Public";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2z5xax9RmBWYV7xNGNZQJKdPY5pUdcFCU+cQoGamvVk=";
  };

  vendorSha256 = "sha256-EswzTlvFbFZK76cl0TKxIcr8Qa7/RcQCvvw+Si323Hs=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X github.com/CircleCI-Public/circleci-cli/version.Version=${version}" "-X github.com/CircleCI-Public/circleci-cli/version.Commit=${src.rev}" "-X github.com/CircleCI-Public/circleci-cli/version.packageManager=nix" ];

  meta = with lib; {
    # Box blurb edited from the AUR package circleci-cli
    description = ''
      Command to enable you to reproduce the CircleCI environment locally and
      run jobs as if they were running on the hosted CirleCI application.
    '';
    maintainers = with maintainers; [ synthetica ];
    license = licenses.mit;
    homepage = "https://circleci.com/";
  };
}
