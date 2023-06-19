{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "typical";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "stepchowfun";
    repo = "typical";
    rev = "v${version}";
    hash = "sha256-pXLOtCzdI6KspNzg1R7Zc97Dd7dX7ZzxvlvKprkLF2I=";
  };

  cargoHash = "sha256-ckW2Hc5BRqtvzZRUAlf7Vy06cgSTY6nv2ompSDNzpi4=";

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
