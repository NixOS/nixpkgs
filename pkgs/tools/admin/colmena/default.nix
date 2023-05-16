{ stdenv, lib, rustPlatform, fetchFromGitHub, installShellFiles, nix-eval-jobs
, colmena, testers }:

rustPlatform.buildRustPackage rec {
  pname = "colmena";
<<<<<<< HEAD
  version = "0.4.0";
=======
  version = "0.3.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "zhaofengli";
    repo = "colmena";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-01bfuSY4gnshhtqA1EJCw2CMsKkAx+dHS+sEpQ2+EAQ=";
  };

  cargoSha256 = "sha256-rk2atWWJIR95duUXxAiARegjeCyfAsqTDwEr5P0eIr8=";
=======
    sha256 = "sha256-F/Jl1GqSp08fw7PCHiv/ijn/pAP1YOStIhHws291s7A=";
  };

  cargoSha256 = "sha256-9HQLSbzHNJRHhGffE0JC9e+CLuUV/xreiv5qc8dH+rU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
    apiVersion = builtins.concatStringsSep "." (lib.take 2 (lib.splitString "." version));

    tests.version = testers.testVersion { package = colmena; };
  };

  meta = with lib; {
    description = "A simple, stateless NixOS deployment tool";
<<<<<<< HEAD
    homepage = "https://colmena.cli.rs/${passthru.apiVersion}";
=======
    homepage = "https://zhaofengli.github.io/colmena/${passthru.apiVersion}";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ zhaofengli ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
