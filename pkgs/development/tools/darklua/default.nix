{ lib
, stdenv
, darwin
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "darklua";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "seaofvoices";
    repo = "darklua";
    rev = "v${version}";
    hash = "sha256-OgQOsc6upMJveUUJSGqvopsyoKs7ALd6pVYxCi5fmS8=";
  };

  cargoHash = "sha256-qq42K4cPrWu/92P4dpegZ/0Wv2ndCb5d5+DgEKzdhbw=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];


  # error: linker `aarch64-linux-gnu-gcc` not found
  postPatch = ''
    rm .cargo/config.toml
  '';

  meta = with lib; {
    description = "A command line tool that transforms Lua code";
    homepage = "https://darklua.com";
    changelog = "https://github.com/seaofvoices/darklua/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ tomodachi94 ];
  };
}
