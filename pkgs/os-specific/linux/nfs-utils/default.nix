{ fetchurl, stdenv, tcpWrapper, e2fsprogs }:

stdenv.mkDerivation rec {
  name = "nfs-utils-1.1.2";

  src = fetchurl {
    url = "mirror://sourceforge/nfs/${name}.tar.gz";
    sha256 = "0cs0kl18f4h8nkbnd7n3flw9krhkm3mx9sh7vz9dkvp46g0v228x";
  };

  patches = [ ./sbindir.patch ];

  # Needs `libblkid' and `libcomerr' from `e2fsprogs'.
  buildInputs = [ tcpWrapper e2fsprogs ];

  # FIXME: Currently too lazy to build the dependencies needed for NFSv4.
  configurePhase = ''./configure --prefix=$out  \
    --disable-gss --disable-nfsv4               \
    --with-statedir=$out/var/lib/nfs'';

  meta = { 
    description = "Linux user-space NFS utilities";

    longDescription = ''
      This package contains various Linux user-space Network File
      System (NFS) utilities, including RPC `mount' and `nfs'
      daemons.
    '';

    homepage = http://nfs.sourceforge.net/;
    license = "GPLv2";
  };
}
