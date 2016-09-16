{ stdenv, fetchFromGitHub, zlib, xz }:

stdenv.mkDerivation rec {
  name = "squashfs-4.4dev";

  src = fetchFromGitHub {
    owner = "plougher";
    repo = "squashfs-tools";
    sha256 = "059pa2shdysr3zfmwrhq28s12zbi5nyzbpzyaf5lmspgfh1493ks";
    rev = "9c1db6d13a51a2e009f0027ef336ce03624eac0d";
  };

  buildInputs = [ zlib xz ];

  preBuild = "cd squashfs-tools";

  installFlags = "INSTALL_DIR=\${out}/bin";

  makeFlags = "XZ_SUPPORT=1";

  meta = {
    homepage = http://squashfs.sourceforge.net/;
    description = "Tool for creating and unpacking squashfs filesystems";
    platforms = stdenv.lib.platforms.linux;
  };
}
