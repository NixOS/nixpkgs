{ lib, rustPlatform, fetchCrate, installShellFiles, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "the-way";
  version = "0.20.2";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-jUo46NHjgSFOV7fsqh9Ki0QtTGfoaPjQ87/a66zBz1Q=";
  };

  cargoHash = "sha256-nmVsg8LX3di7ZAvvDuPQ3PXlLjs+L6YFTzwXRAkcxig=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
  ];

  useNextest = true;

  postInstall = ''
    $out/bin/the-way config default tmp.toml
    for shell in bash fish zsh; do
      THE_WAY_CONFIG=tmp.toml $out/bin/the-way complete $shell > the-way.$shell
      installShellCompletion the-way.$shell
    done
  '';

  meta = with lib; {
    description = "Terminal code snippets manager";
    homepage = "https://github.com/out-of-cheese-error/the-way";
    changelog = "https://github.com/out-of-cheese-error/the-way/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ figsoda numkem ];
  };
}
