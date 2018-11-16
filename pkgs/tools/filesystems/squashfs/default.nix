{ stdenv, fetchFromGitHub, zlib, xz
, lz4 ? null
, lz4Support ? false
}:

assert lz4Support -> (lz4 != null);

stdenv.mkDerivation rec {
  name = "squashfs-4.4dev";

  src = fetchFromGitHub {
    owner = "plougher";
    repo = "squashfs-tools";
    sha256 = "059pa2shdysr3zfmwrhq28s12zbi5nyzbpzyaf5lmspgfh1493ks";
    rev = "9c1db6d13a51a2e009f0027ef336ce03624eac0d";
  };

  # These patches ensures that mksquashfs output is reproducible.
  # See also https://reproducible-builds.org/docs/system-images/
  # and https://github.com/NixOS/nixpkgs/issues/40144.
  patches = [
    ./0001-If-SOURCE_DATE_EPOCH-is-set-override-timestamps-with.patch
    ./0002-If-SOURCE_DATE_EPOCH-is-set-also-clamp-content-times.patch
    ./0003-remove-frag-deflator-thread.patch
  ] ++ stdenv.lib.optional stdenv.isDarwin ./darwin.patch;

  buildInputs = [ zlib xz ]
    ++ stdenv.lib.optional lz4Support lz4;

  preBuild = "cd squashfs-tools";

  installFlags = "INSTALL_DIR=\${out}/bin";

  makeFlags = [ "XZ_SUPPORT=1" ]
    ++ stdenv.lib.optional lz4Support "LZ4_SUPPORT=1";

  meta = {
    homepage = http://squashfs.sourceforge.net/;
    description = "Tool for creating and unpacking squashfs filesystems";
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ ruuda ];
  };
}
