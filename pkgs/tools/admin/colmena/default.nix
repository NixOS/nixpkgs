{ stdenv, lib, rustPlatform, fetchFromGitHub, installShellFiles, colmena, testVersion }:

rustPlatform.buildRustPackage rec {
  pname = "colmena";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "zhaofengli";
    repo = "colmena";
    rev = "v${version}";
    sha256 = "sha256-WY8SYapnDcfaoLr1iFgwc9/E7xSfOFN2AvMDpk74AI8=";
  };

  cargoSha256 = "sha256-ZNSg3hXWKHNQ9yHJS1qW3tFYwzU4ZDa1N0yvoGLmWns=";

  nativeBuildInputs = [ installShellFiles ];

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

    tests.version = testVersion { package = colmena; };
  };

  meta = with lib; {
    description = "A simple, stateless NixOS deployment tool";
    homepage = "https://zhaofengli.github.io/colmena/${passthru.apiVersion}";
    license = licenses.mit;
    maintainers = with maintainers; [ zhaofengli ];
    platforms = platforms.linux;
  };
}
