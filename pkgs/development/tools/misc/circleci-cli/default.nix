{ lib, fetchFromGitHub, buildGoModule, installShellFiles }:

buildGoModule rec {
  pname = "circleci-cli";
  version = "0.1.30888";

  src = fetchFromGitHub {
    owner = "CircleCI-Public";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ZnU48pj1xv2GuiDW/lsKzOcdLbwKyVupV0PBw7CJvm0=";
  };

  vendorHash = "sha256-60edYYhbSPiJWmuQXXEt+xCnSxsHf8Q38RgyWwdP6vQ=";

  nativeBuildInputs = [ installShellFiles ];

  doCheck = false;

  ldflags = [ "-s" "-w" "-X github.com/CircleCI-Public/circleci-cli/version.Version=${version}" "-X github.com/CircleCI-Public/circleci-cli/version.Commit=${src.rev}" "-X github.com/CircleCI-Public/circleci-cli/version.packageManager=nix" ];

  postInstall = ''
    mv $out/bin/circleci-cli $out/bin/circleci

    installShellCompletion --cmd circleci \
      --bash <(HOME=$TMPDIR $out/bin/circleci completion bash --skip-update-check) \
      --zsh <(HOME=$TMPDIR $out/bin/circleci completion zsh --skip-update-check)
  '';

  meta = with lib; {
    # Box blurb edited from the AUR package circleci-cli
    description = ''
      Command to enable you to reproduce the CircleCI environment locally and
      run jobs as if they were running on the hosted CirleCI application.
    '';
    maintainers = with maintainers; [ synthetica ];
    mainProgram = "circleci";
    license = licenses.mit;
    homepage = "https://circleci.com/";
  };
}
