{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  libssh2,
  openssl,
  zlib,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-workspaces";
  version = "0.3.5";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-eNZOtbN3WH7/Y0RjXZCPRxC4Yv0kEtVSqMLsyznPGwU=";
  };

  cargoHash = "sha256-B5Pc9nzMf9N6FTY1KZ+lj7/RSbJiK/ahotztoopzABk=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      libssh2
      openssl
      zlib
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  env = {
    LIBSSH2_SYS_USE_PKG_CONFIG = true;
  };

  meta = with lib; {
    description = "A tool for managing cargo workspaces and their crates, inspired by lerna";
    longDescription = ''
      A tool that optimizes the workflow around cargo workspaces with
      git and cargo by providing utilities to version, publish, execute
      commands and more.
    '';
    homepage = "https://github.com/pksunkara/cargo-workspaces";
    changelog = "https://github.com/pksunkara/cargo-workspaces/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [
      figsoda
      macalinao
      matthiasbeyer
    ];
    mainProgram = "cargo-workspaces";
  };
}
