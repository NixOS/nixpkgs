{ stdenv, lib, rustPlatform, fetchFromGitHub, installShellFiles, colmena, testVersion }:

rustPlatform.buildRustPackage rec {
  pname = "colmena";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "zhaofengli";
    repo = "colmena";
    rev = "v${version}";
    sha256 = "sha256-5UU8iBzwO7xM8B+LulnFkJFv5j5lu7mfq0XMmOCaKcQ=";
  };

  cargoSha256 = "sha256-wMC2GAVVxkwrgJtOIJL0P+Uxh+ouW4VwLDrXJlD10AA=";

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
