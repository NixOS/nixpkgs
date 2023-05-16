{ lib
, writeText
, rustPlatform
, fetchFromGitHub
, curl
, installShellFiles
<<<<<<< HEAD
, pkg-config
, bzip2
, libgit2_1_6
=======
, makeBinaryWrapper
, pkg-config
, bzip2
, libgit2_1_5
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  version = "0.2.4";
=======
  version = "0.2.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nix-init";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-VP0UwJhiY6gDF3tBI1DOW0B4XAl9CzTHzgIP68iF4VM=";
  };

  cargoHash = "sha256-x1zRQGWN2NOvDDrQgkeObf6eNoCGMSw3DVgwVqfbI48=";
=======
    hash = "sha256-QxGPBGCCjbQ1QbJNoW0dwQS/srwQ0hBR424zmcqdjI8=";
  };

  cargoHash = "sha256-+Vj3TqNxMgaUmhzCgSEGl58Jh1PLsC6q/DfDbfg2mmo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    curl
    installShellFiles
<<<<<<< HEAD
=======
    makeBinaryWrapper
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pkg-config
  ];

  buildInputs = [
    bzip2
    curl
<<<<<<< HEAD
    libgit2_1_6
=======
    libgit2_1_5
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
=======
    wrapProgram $out/bin/nix-init \
      --prefix PATH : ${lib.makeBinPath [ nix nurl ]}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    installManPage artifacts/nix-init.1
    installShellCompletion artifacts/nix-init.{bash,fish} --zsh artifacts/_nix-init
  '';

  env = {
    GEN_ARTIFACTS = "artifacts";
<<<<<<< HEAD
    NIX = lib.getExe nix;
    NURL = lib.getExe nurl;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
