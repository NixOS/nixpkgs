{ stdenv, lib, fetchpatch, rustPlatform, fetchFromGitHub, installShellFiles, makeBinaryWrapper, nix-eval-jobs, nix
, colmena, testers }:

rustPlatform.buildRustPackage rec {
  pname = "colmena";
  version = "0.4.0-unstable-2024-11-08";

  src = fetchFromGitHub {
    owner = "zhaofengli";
    repo = "colmena";
    rev = "03f1a18a6fba9ad9c4edb1cc7cf394390c304198";
    hash = "sha256-N8gaV5bngMQPGyuo/RVdEsHTXvOeqjUhhxXpGea12DE=";
  };

  cargoHash = "sha256-RwZNQhfpU2yGg4Nz3Yc7NBb4Eg3LeFX+HQzBknCIAIk=";

  nativeBuildInputs = [ installShellFiles makeBinaryWrapper ];

  buildInputs = [ nix-eval-jobs ];

  NIX_EVAL_JOBS = "${nix-eval-jobs}/bin/nix-eval-jobs";

  patches = [
    # Fixes nix 2.24 compat: https://github.com/zhaofengli/colmena/pull/236
    (fetchpatch {
      url = "https://github.com/zhaofengli/colmena/commit/36382ee2bef95983848435065f7422500c7923a8.patch";
      sha256 = "sha256-5cQ2u3eTzhzjPN+rc6xWIskHNtheVXXvlSeJ1G/lz+E=";
    })
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd colmena \
      --bash <($out/bin/colmena gen-completions bash) \
      --zsh <($out/bin/colmena gen-completions zsh) \
      --fish <($out/bin/colmena gen-completions fish)

    wrapProgram $out/bin/colmena \
      --prefix PATH ":" "${lib.makeBinPath [ nix ]}"
  '';

  # Recursive Nix is not stable yet
  doCheck = false;

  passthru = {
    # We guarantee CLI and Nix API stability for the same minor version
    apiVersion = builtins.concatStringsSep "." (lib.take 2 (lib.splitVersion version));

    tests.version = testers.testVersion { package = colmena; };
  };

  meta = with lib; {
    description = "Simple, stateless NixOS deployment tool";
    homepage = "https://colmena.cli.rs/${passthru.apiVersion}";
    license = licenses.mit;
    maintainers = with maintainers; [ zhaofengli ];
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "colmena";
  };
}
