{ fetchurl, stdenv, tcpWrapper, libuuid }:

stdenv.mkDerivation rec {
  name = "nfs-utils-1.2.0";

  src = fetchurl {
    url = "mirror://sourceforge/nfs/${name}.tar.bz2";
    sha256 = "1ld1f6wcm53pza3zy768y1y8xa01zq3bnjyy1j3z62yd7a5lcffb";
  };

  # Needs `libblkid' and `libcomerr' from `e2fsprogs' or `util-linux-ng'.
  buildInputs = [ tcpWrapper libuuid ];

  # FIXME: Currently too lazy to build the dependencies needed for NFSv4.
  configureFlags = "--disable-gss --disable-nfsv4 --with-statedir=/var/lib/nfs";

  preBuild =
    ''
      makeFlags="sbindir=$out/sbin"
      installFlags="statedir=$TMPDIR" # hack to make `make install' work
    '';

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
