{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, makeWrapper
, pkg-config
, zstd
, stdenv
, darwin
, nix
, nurl
, callPackage
, spdx-license-list-data
}:

rustPlatform.buildRustPackage rec {
  pname = "nix-init";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nix-init";
    rev = "v${version}";
    hash = "sha256-97aAlH03H8xTVhp45FwecNb7i/ZUtJG9OOYBx8Sf+YI=";
  };

  cargoHash = "sha256-uvn1cP6aIxfPKG/QLtHBd6fHjl7JNRtkZ4gIG2tpHVg=";

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    zstd
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  postInstall = ''
    wrapProgram $out/bin/nix-init \
      --prefix PATH : ${lib.makeBinPath [ nix nurl ]}
    installManPage artifacts/nix-init.1
    installShellCompletion artifacts/nix-init.{bash,fish} --zsh artifacts/_nix-init
  '';

  GEN_ARTIFACTS = "artifacts";
  NIX_LICENSES = callPackage ./license.nix { };
  SPDX_LICENSE_LIST_DATA = "${spdx-license-list-data.json}/json/details";
  ZSTD_SYS_USE_PKG_CONFIG = true;

  meta = with lib; {
    description = "Command line tool to generate Nix packages from URLs";
    homepage = "https://github.com/nix-community/nix-init";
    changelog = "https://github.com/nix-community/nix-init/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
