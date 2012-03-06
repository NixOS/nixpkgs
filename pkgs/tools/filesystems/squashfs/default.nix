{ stdenv, fetchurl, zlib, xz }:

stdenv.mkDerivation rec {
  name = "squashfs-4.2";

  src = fetchurl {
    url = mirror://sourceforge/squashfs/squashfs4.2.tar.gz;
    sha256 = "15if08j0pl5hmnz9pwshwrp4fjp0jsm9larjxmjvdnr2m5d1kq6r";
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
