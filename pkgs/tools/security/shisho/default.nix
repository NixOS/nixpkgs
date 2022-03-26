{ lib
, fetchFromGitHub
, rustPlatform
, installShellFiles
, rustfmt
}:

rustPlatform.buildRustPackage rec {
  pname = "shisho";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "flatt-security";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-G7sHaDq+F5lXNaF1sSLUecdjZbCejJE79P4AQifKdFY=";
    fetchSubmodules = true;
  };
  cargoSha256 = "sha256-xd4andytmDMOIT+3DkmUC9fkxxGJ6yRY2WSdnGB6ZwY=";

  nativeBuildInputs = [
    installShellFiles
    # required to build serde-sarif dependency
    rustfmt
  ];

  postInstall = ''
    installShellCompletion --cmd shisho \
      --bash <($out/bin/shisho completion bash) \
      --fish <($out/bin/shisho completion fish) \
      --zsh <($out/bin/shisho completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/shisho --help
    $out/bin/shisho --version | grep "${version}"

    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://docs.shisho.dev/shisho/";
    changelog = "https://docs.shisho.dev/changelog/";
    description = "Lightweight static analyzer for several programming languages";
    longDescription = ''
      Shisho is a lightweight static code analyzer designed for developers and
      is the core engine for Shisho products. It is, so to speak, like a
      pluggable and configurable linter; it gives developers a way to codify
      your domain knowledge over your code as rules. With powerful automation
      and integration capabilities, the rules will help you find and fix issues
      semiautomatically.
    '';
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ jk ];
  };
}
