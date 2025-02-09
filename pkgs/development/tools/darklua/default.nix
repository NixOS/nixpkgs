{ lib
, stdenv
, darwin
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "darklua";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "seaofvoices";
    repo = "darklua";
    rev = "v${version}";
    hash = "sha256-9ukhKAhN4dD36Em90Eox8o+7W1eXboG2xAE8+oPlhaI=";
  };

  cargoHash = "sha256-hi9kzCwsw8c1tcvSsFV0do/jQ/KyDz3TcTEfOqHNxyw=";

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
