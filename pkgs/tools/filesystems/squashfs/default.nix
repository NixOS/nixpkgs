{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, help2man
, lz4
, lzo
, nixosTests
, which
, xz
, zlib
, zstd
}:

stdenv.mkDerivation rec {
  pname = "squashfs";
  version = "4.6.1";

  src = fetchFromGitHub {
    owner = "plougher";
    repo = "squashfs-tools";
    rev = version;
    hash = "sha256-C/awQpp1Q/0adx3YVNTq6ruEAzcjL5G7SkOCgpvAA50=";
  };

  patches = [
    # This patch adds an option to pad filesystems (increasing size) in
    # exchange for better chunking / binary diff calculation.
    ./4k-align.patch
  ];

  strictDeps = true;
  nativeBuildInputs = [ which ]
    # when cross-compiling help2man cannot run the cross-compiled binary
    ++ lib.optionals (stdenv.hostPlatform == stdenv.buildPlatform) [ help2man ];
  buildInputs = [ zlib xz zstd lz4 lzo ];

  preBuild = ''
    cd squashfs-tools
  '' ;

  installFlags = [
    "INSTALL_DIR=${placeholder "out"}/bin"
    "INSTALL_MANPAGES_DIR=${placeholder "out"}/share/man/man1"
  ];

  makeFlags = [
    "XZ_SUPPORT=1"
    "ZSTD_SUPPORT=1"
    "LZ4_SUPPORT=1"
    "LZO_SUPPORT=1"
  ];

  passthru.tests = {
    nixos-iso-boots-and-verifies = nixosTests.boot.biosCdrom;
  };

  meta = with lib; {
    homepage = "https://github.com/plougher/squashfs-tools";
    description = "Tool for creating and unpacking squashfs filesystems";
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ruuda ];
    mainProgram = "mksquashfs";
  };
}
