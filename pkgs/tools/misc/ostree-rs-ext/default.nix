{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  glib,
  openssl,
  zlib,
  ostree,
  stdenv,
  darwin,
  util-linux,
  skopeo,
  gnutar,
  ima-evm-utils,
}:

rustPlatform.buildRustPackage rec {
  pname = "ostree-rs-ext";
  version = "0.10.6";

  src = fetchFromGitHub {
    owner = "ostreedev";
    repo = "ostree-rs-ext";
    rev = "ostree-ext-v${version}";
    hash = "sha256-kk/icUevzKMpAQ6IoruUxuKwTxXHlKLrr63Hch1w7po=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs =
    [
      glib
      openssl
      zlib
      ostree
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.CoreFoundation
      darwin.apple_sdk.frameworks.Security
    ];

  checkFlags = [
    # these tests expects /var/tmp to be available
    "--skip=test_cli_fns"
    "--skip=test_container_chunked"
    "--skip=test_container_import_export_v1"
    "--skip=test_container_var_content"
    "--skip=test_container_write_derive"
    "--skip=test_container_write_derive_sysroot_hardlink"
    "--skip=test_diff"
    "--skip=test_tar_export_reproducible"
    "--skip=test_tar_export_structure"
    "--skip=test_tar_import_empty"
    "--skip=test_tar_import_export"
    "--skip=test_tar_import_signed"
    "--skip=test_tar_write"
    "--skip=test_tar_write_tar_layer"
  ];

  postInstall = ''
    wrapProgram "$out/bin/${meta.mainProgram}" --prefix PATH : ${
      lib.makeBinPath [
        util-linux
        skopeo
        gnutar
        ostree
        ima-evm-utils
      ]
    }
  '';

  meta = with lib; {
    description = "Rust library with higher level APIs on top of the core ostree API";
    homepage = "https://github.com/ostreedev/ostree-rs-ext";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ nickcao ];
    mainProgram = "ostree-ext-cli";
  };
}
