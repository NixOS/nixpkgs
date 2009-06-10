{stdenv, fetchurl, zlib}:

stdenv.mkDerivation rec {
  name = "squashfs-4.0";

  src = fetchurl {
    url = mirror://sourceforge/squashfs/squashfs4.0.tar.gz;
    sha256 = "089fw543fx2d3dadszjv5swf8hr6jvxrpagf0x1jrb3bw3dqx50q";
  };
  
  buildInputs = [zlib];

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
