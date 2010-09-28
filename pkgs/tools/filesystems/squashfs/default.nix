{stdenv, fetchurl, zlib, attr}:

stdenv.mkDerivation rec {
  name = "squashfs-4.1";

  src = fetchurl {
    url = mirror://sourceforge/squashfs/squashfs4.1.tar.gz;
    sha256 = "0sh40r7gz81fg7ivgr7rld8spvqb6hsfvnf6gd3gbcr5b830v1rs";
  };
  
  buildInputs = [zlib attr];

  preBuild = ''
    cd squashfs-tools
  '';

  NIX_LDFLAGS = "-lgcc_s"; # for pthread_cancel

  installFlags = "INSTALL_DIR=\${out}/bin";

  meta = {
    homepage = http://squashfs.sourceforge.net/;
    description = "Tool for creating and unpacking squashfs filesystems";
  };
}
