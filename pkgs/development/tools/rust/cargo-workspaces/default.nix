{ lib
, rustPlatform
, fetchCrate
, pkg-config
, libgit2_1_6
, libssh2
, openssl
, zlib
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-workspaces";
  version = "0.3.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-1wNoMVfouuPRGFGB6XIhgeeWgknxMctrBl5Vfco6qug=";
  };

  cargoHash = "sha256-OJGqIo6mYqXjmQb/2CVVTskecYZretw+K46Fvbu/PcQ=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2_1_6
    libssh2
    openssl
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
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
    maintainers = with maintainers; [ figsoda macalinao matthiasbeyer ];
    mainProgram = "cargo-workspaces";
  };
}
