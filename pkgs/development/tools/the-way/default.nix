{ lib, rustPlatform, fetchCrate, installShellFiles, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "the-way";
  version = "0.18.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-UgD9ulJtRlNuux80FQhgLYjJ6OsyWXZCBGY9qdmd9Jk=";
  };

  cargoSha256 = "sha256-z5+71I/q1+vz2CPAU06yjRSjpKyT6npjPi48lu21NZs=";

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
