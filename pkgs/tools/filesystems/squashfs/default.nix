{ stdenv, fetchurl, zlib, xz }:

stdenv.mkDerivation rec {
  name = "squashfs-4.3";

  src = fetchurl {
    url = mirror://sourceforge/squashfs/squashfs4.3.tar.gz;
    sha256 = "1xpklm0y43nd9i6jw43y2xh5zvlmj9ar2rvknh0bh7kv8c95aq0d";
  };

  buildInputs = [ zlib xz ];

  preBuild = "cd squashfs-tools";

  NIX_LDFLAGS = "-lgcc_s"; # for pthread_cancel

  installFlags = "INSTALL_DIR=\${out}/bin";

  makeFlags = "XZ_SUPPORT=1";

  meta = {
    homepage = http://squashfs.sourceforge.net/;
    description = "Tool for creating and unpacking squashfs filesystems";
  };
}
