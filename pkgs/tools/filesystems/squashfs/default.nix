{ stdenv, fetchFromGitHub, zlib, xz
, lz4 ? null
, lz4Support ? false
, zstd
}:

assert lz4Support -> (lz4 != null);

stdenv.mkDerivation rec {
  name = "squashfs-${version}";
  version = "4.4dev_20180612";

  src = fetchFromGitHub {
    owner = "plougher";
    repo = "squashfs-tools";
    sha256 = "1y53z8dkph3khdyhkmkmy0sg9p1n8czv3vj4l324nj8kxyih3l2c";
    rev = "6e242dc95485ada8d1d0b3dd9346c5243d4a517f";
  };

  patches = [
    # These patches ensures that mksquashfs output is reproducible.
    # See also https://reproducible-builds.org/docs/system-images/
    # and https://github.com/NixOS/nixpkgs/issues/40144.
    ./0001-If-SOURCE_DATE_EPOCH-is-set-override-timestamps-with.patch
    ./0002-If-SOURCE_DATE_EPOCH-is-set-also-clamp-content-times.patch
    ./0003-remove-frag-deflator-thread.patch

    # This patch adds an option to pad filesystems (increasing size) in
    # exchange for better chunking / binary diff calculation.
    ./squashfs-tools-4.3-4k-align.patch
  ] ++ stdenv.lib.optional stdenv.isDarwin ./darwin.patch;

  buildInputs = [ zlib xz zstd ]
    ++ stdenv.lib.optional lz4Support lz4;

  preBuild = "cd squashfs-tools";

  installFlags = "INSTALL_DIR=\${out}/bin";

  makeFlags = [ "XZ_SUPPORT=1" "ZSTD_SUPPORT=1" ]
    ++ stdenv.lib.optional lz4Support "LZ4_SUPPORT=1";

  meta = {
    homepage = http://squashfs.sourceforge.net/;
    description = "Tool for creating and unpacking squashfs filesystems";
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ ruuda ];
  };
}
