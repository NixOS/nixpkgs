{ lib
, stdenv
, fetchFromGitHub
, pkg-config
<<<<<<< HEAD
, libuuid
=======
, docutils
, libuuid
, libscrypt
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, libsodium
, keyutils
, liburcu
, zlib
, libaio
, zstd
, lz4
<<<<<<< HEAD
, attr
, udev
, valgrind
, nixosTests
, fuse3
, cargo
, rustc
, coreutils
, rustPlatform
, makeWrapper
, fuseSupport ? false
}:
let
  rev = "cfa816bf3f823a3bedfedd8e214ea929c5c755fe";
in stdenv.mkDerivation {
  pname = "bcachefs-tools";
  version = "unstable-2023-06-28";
=======
, python3Packages
, util-linux
, udev
, valgrind
, nixosTests
, makeWrapper
, getopt
, fuse3
, fuseSupport ? false
}:

stdenv.mkDerivation {
  pname = "bcachefs-tools";
  version = "unstable-2023-01-31";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "koverstreet";
    repo = "bcachefs-tools";
<<<<<<< HEAD
    inherit rev;
    hash = "sha256-XgXUwyZV5N8buYTuiu1Y1ZU3uHXjZ/OZ1kbZ9d6Rt5I=";
  };

  # errors on fsck_err function. Maybe miss-detection?
  NIX_CFLAGS_COMPILE = "-Wno-error=format-security";

  nativeBuildInputs = [
    pkg-config
    cargo
    rustc
    rustPlatform.cargoSetupHook
    rustPlatform.bindgenHook
    makeWrapper
  ];

  cargoRoot = "rust-src";
  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "bindgen-0.64.0" = "sha256-GNG8as33HLRYJGYe0nw6qBzq86aHiGonyynEM7gaEE4=";
    };
  };

  buildInputs = [
    libaio
    keyutils
    lz4

    libsodium
    liburcu
    libuuid
    zstd
    zlib
    attr
    udev
=======
    rev = "3c39b422acd3346321185be0ce263809e2a9a23f";
    hash = "sha256-2ci/m4JfodLiPoWfP+QCEqlk0k48zq3mKb8Pdrtln0o=";
  };

  postPatch = ''
    patchShebangs .
    substituteInPlace Makefile \
      --replace "pytest-3" "pytest --verbose" \
      --replace "INITRAMFS_DIR=/etc/initramfs-tools" \
                "INITRAMFS_DIR=${placeholder "out"}/etc/initramfs-tools"
  '';

  nativeBuildInputs = [
    pkg-config docutils python3Packages.python makeWrapper
  ];

  buildInputs = [
    libuuid libscrypt libsodium keyutils liburcu zlib libaio
    zstd lz4 python3Packages.pytest udev valgrind
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ] ++ lib.optional fuseSupport fuse3;

  doCheck = false; # needs bcachefs module loaded on builder
  checkFlags = [ "BCACHEFS_TEST_USE_VALGRIND=no" ];
  nativeCheckInputs = [ valgrind ];

<<<<<<< HEAD
  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "VERSION=${lib.strings.substring 0 7 rev}"
    "INITRAMFS_DIR=${placeholder "out"}/etc/initramfs-tools"
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  preCheck = lib.optionalString fuseSupport ''
    rm tests/test_fuse.py
  '';

<<<<<<< HEAD
=======
  # this symlink is needed for mount -t bcachefs to work
  postFixup = ''
    ln -s $out/bin/mount.bcachefs.sh $out/bin/mount.bcachefs
    wrapProgram $out/bin/mount.bcachefs.sh \
      --prefix PATH : ${lib.makeBinPath [ getopt util-linux ]}
  '';

  installFlags = [ "PREFIX=${placeholder "out"}" ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  passthru.tests = {
    smoke-test = nixosTests.bcachefs;
    inherit (nixosTests.installer) bcachefsSimple bcachefsEncrypted bcachefsMulti;
  };

<<<<<<< HEAD
  postFixup = ''
    wrapProgram $out/bin/mount.bcachefs \
      --prefix PATH : ${lib.makeBinPath [ coreutils ]}
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  enableParallelBuilding = true;

  meta = with lib; {
    description = "Tool for managing bcachefs filesystems";
    homepage = "https://bcachefs.org/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ davidak Madouura ];
    platforms = platforms.linux;
  };
}
