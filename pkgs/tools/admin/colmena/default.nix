{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nix-eval-jobs,
  colmena,
  testers,
}:

rustPlatform.buildRustPackage rec {
  pname = "colmena";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "zhaofengli";
    repo = "colmena";
    rev = "v${version}";
    sha256 = "sha256-01bfuSY4gnshhtqA1EJCw2CMsKkAx+dHS+sEpQ2+EAQ=";
  };

  cargoSha256 = "sha256-rk2atWWJIR95duUXxAiARegjeCyfAsqTDwEr5P0eIr8=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ nix-eval-jobs ];

  NIX_EVAL_JOBS = "${nix-eval-jobs}/bin/nix-eval-jobs";

  postInstall = lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
    installShellCompletion --cmd colmena \
      --bash <($out/bin/colmena gen-completions bash) \
      --zsh <($out/bin/colmena gen-completions zsh) \
      --fish <($out/bin/colmena gen-completions fish)
  '';

  # Recursive Nix is not stable yet
  doCheck = false;

  passthru = {
    # We guarantee CLI and Nix API stability for the same minor version
    apiVersion = builtins.concatStringsSep "." (lib.take 2 (lib.splitVersion version));

    tests.version = testers.testVersion { package = colmena; };
  };

  meta = with lib; {
    description = "A simple, stateless NixOS deployment tool";
    homepage = "https://colmena.cli.rs/${passthru.apiVersion}";
    license = licenses.mit;
    maintainers = with maintainers; [ zhaofengli ];
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "colmena";
  };
}
