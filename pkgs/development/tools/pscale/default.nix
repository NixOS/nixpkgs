{ buildGoModule
, fetchFromGitHub
, installShellFiles
, lib
, pscale
, testers
}:

buildGoModule rec {
  pname = "pscale";
<<<<<<< HEAD
  version = "0.154.0";
=======
  version = "0.142.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "planetscale";
    repo = "cli";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-TExrsxG+7K0QLuMmmIuNcmkFuU9jxbZsQSPxm1q+F0Q=";
  };

  vendorHash = "sha256-hj+uzb1mpFrbbZXozCP9166i0C5pwIKhEtJOxovBCZE=";
=======
    sha256 = "sha256-d4Sr9QKhCFGsJWWp19RQBsXR656ACJU/ti0FrZ8DmlQ=";
  };

  vendorHash = "sha256-KLbIov3PTEXq+MAwN0NnRLcr8LGTk+F+he1BUgoJn2o=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [
    "-s" "-w"
    "-X main.version=v${version}"
    "-X main.commit=v${version}"
    "-X main.date=unknown"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd pscale \
      --bash <($out/bin/pscale completion bash) \
      --fish <($out/bin/pscale completion fish) \
      --zsh <($out/bin/pscale completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = pscale;
  };

  meta = with lib; {
    description = "The CLI for PlanetScale Database";
    changelog = "https://github.com/planetscale/cli/releases/tag/v${version}";
    homepage = "https://www.planetscale.com/";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ pimeys kashw2 ];
=======
    maintainers = with maintainers; [ pimeys ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
