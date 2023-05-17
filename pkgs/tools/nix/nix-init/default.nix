{ lib
, writeText
, rustPlatform
, fetchFromGitHub
, curl
, installShellFiles
, makeBinaryWrapper
, pkg-config
, bzip2
, libgit2_1_5
, openssl
, zlib
, zstd
, stdenv
, darwin
, spdx-license-list-data
, nix
, nurl
}:

let
  get-nix-license = import ./get-nix-license.nix {
    inherit lib writeText;
  };
in

rustPlatform.buildRustPackage rec {
  pname = "nix-init";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nix-init";
    rev = "v${version}";
    hash = "sha256-QxGPBGCCjbQ1QbJNoW0dwQS/srwQ0hBR424zmcqdjI8=";
  };

  cargoHash = "sha256-+Vj3TqNxMgaUmhzCgSEGl58Jh1PLsC6q/DfDbfg2mmo=";

  nativeBuildInputs = [
    curl
    installShellFiles
    makeBinaryWrapper
    pkg-config
  ];

  buildInputs = [
    bzip2
    curl
    libgit2_1_5
    openssl
    zlib
    zstd
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ] ++ lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [
    darwin.apple_sdk.frameworks.CoreFoundation
  ];

  buildNoDefaultFeatures = true;

  checkFlags = [
    # requires internet access
    "--skip=lang::rust::tests"
  ];

  postPatch = ''
    mkdir -p data
    ln -s ${get-nix-license} data/get-nix-license.rs
  '';

  preBuild = ''
    cargo run -p license-store-cache \
      -j $NIX_BUILD_CORES --frozen \
      data/license-store-cache.zstd ${spdx-license-list-data.json}/json/details
  '';

  postInstall = ''
    wrapProgram $out/bin/nix-init \
      --prefix PATH : ${lib.makeBinPath [ nix nurl ]}
    installManPage artifacts/nix-init.1
    installShellCompletion artifacts/nix-init.{bash,fish} --zsh artifacts/_nix-init
  '';

  env = {
    GEN_ARTIFACTS = "artifacts";
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  meta = with lib; {
    description = "Command line tool to generate Nix packages from URLs";
    homepage = "https://github.com/nix-community/nix-init";
    changelog = "https://github.com/nix-community/nix-init/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
