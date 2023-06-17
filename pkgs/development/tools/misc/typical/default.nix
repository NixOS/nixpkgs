{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "typical";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "stepchowfun";
    repo = "typical";
    rev = "v${version}";
    hash = "sha256-4OByyczbHucav9v9pXqWYyreG+F36G0IodcDTedJxic=";
  };

  cargoHash = "sha256-BtnPCMBPVUGL+6ufhE2TF+dnHCeC/12DMHBaTPlYqBg=";

  nativeBuildInputs = [
    installShellFiles
  ];

  preCheck = ''
    export NO_COLOR=true
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd typical \
      --bash <($out/bin/typical shell-completion bash) \
      --fish <($out/bin/typical shell-completion fish) \
      --zsh <($out/bin/typical shell-completion zsh)
  '';

  meta = with lib; {
    description = "Data interchange with algebraic data types";
    homepage = "https://github.com/stepchowfun/typical";
    changelog = "https://github.com/stepchowfun/typical/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
