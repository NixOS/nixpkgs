{ lib
, writeText
, rustPlatform
, fetchFromGitHub
, curl
, installShellFiles
, pkg-config
, bzip2
, libgit2
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
  get-nix-license = import ./get_nix_license.nix {
    inherit lib writeText;
  };
in

rustPlatform.buildRustPackage rec {
  pname = "nix-init";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nix-init";
    rev = "v${version}";
    hash = "sha256-YUstBO+iznr0eJYVJdNQ2BjDhvviRQuojhT9IlTuR0k=";
  };

  cargoHash = "sha256-OAgEzf+EyrwjNa40BwPwSNZ4lhEH93YxCbPJJ3r7oSQ=";

  nativeBuildInputs = [
    curl
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    bzip2
    curl
    libgit2
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
    ln -s ${get-nix-license} data/get_nix_license.rs
  '';

  preBuild = ''
    cargo run -p license-store-cache \
      -j $NIX_BUILD_CORES --frozen \
      data/license-store-cache.zstd ${spdx-license-list-data.json}/json/details
  '';

  postInstall = ''
    installManPage artifacts/nix-init.1
    installShellCompletion artifacts/nix-init.{bash,fish} --zsh artifacts/_nix-init
  '';

  env = {
    GEN_ARTIFACTS = "artifacts";
    LIBGIT2_NO_VENDOR = 1;
    NIX = lib.getExe nix;
    NURL = lib.getExe nurl;
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  meta = with lib; {
    description = "Command line tool to generate Nix packages from URLs";
    mainProgram = "nix-init";
    homepage = "https://github.com/nix-community/nix-init";
    changelog = "https://github.com/nix-community/nix-init/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
