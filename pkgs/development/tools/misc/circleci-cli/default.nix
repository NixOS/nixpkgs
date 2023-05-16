{ lib, fetchFromGitHub, buildGoModule, installShellFiles }:

buildGoModule rec {
  pname = "circleci-cli";
<<<<<<< HEAD
  version = "0.1.28995";
=======
  version = "0.1.26343";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "CircleCI-Public";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-+Gyv3GO6nOueswPAriUm7QkQgEkYEilnBT7hqmiqDW8=";
  };

  vendorHash = "sha256-OWdJ7nFR5hrKQf2H763ezjXkEh0PvtBcjjeSNvH+ca4=";
=======
    sha256 = "sha256-mEvrcZbQ8vcRHL1CWlxzBJFqXLTJi51DER9BKLxnJ+4=";
  };

  vendorHash = "sha256-LzDofZI54cWP4FQfINq3tQbSi4c9/N1v0YH/aSzttNo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
