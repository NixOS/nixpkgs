{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, testers
, helm-ls
}:

buildGoModule rec {
  pname = "helm-ls";
<<<<<<< HEAD
  version = "0.0.5";
=======
  version = "0.0.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mrjosh";
    repo = "helm-ls";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-GRnE9GC9pIcOfcVtlqx/yCkQz9rmxpkAfRGa6GZBzJE=";
  };

  vendorHash = "sha256-wMYrgAgAEgwfjMLP81H0cKWm/kh63ppDkSiymfsaj7U=";
=======
    hash = "sha256-MiDbV+mfr1wcc0e0iwFPL8WniWKbPnr4zb79qniT2Kc=";
  };

  vendorHash = "sha256-EqZlmOoQtC3Iuf0LG2PL0K2pluGqbyA6132lzgF4+ic=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  postInstall = ''
    mv $out/bin/helm-ls $out/bin/helm_ls
    installShellCompletion --cmd helm_ls \
      --bash <($out/bin/helm_ls completion bash) \
      --fish <($out/bin/helm_ls completion fish) \
      --zsh <($out/bin/helm_ls completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = helm-ls;
    command = "helm_ls version";
  };

  meta = with lib; {
    description = "Language server for Helm";
    changelog = "https://github.com/mrjosh/helm-ls/releases/tag/v${version}";
    homepage = "https://github.com/mrjosh/helm-ls";
    license = licenses.mit;
    maintainers = with maintainers; [ stehessel ];
    mainProgram = "helm_ls";
  };
}
