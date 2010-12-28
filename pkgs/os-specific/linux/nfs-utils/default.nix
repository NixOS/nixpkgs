{ fetchurl, stdenv, tcpWrapper, utillinuxng, libcap }:

stdenv.mkDerivation rec {
  name = "nfs-utils-1.2.3";

  src = fetchurl {
    url = "mirror://sourceforge/nfs/${name}.tar.bz2";
    sha256 = "06gzb4idg6rkr4wpj7lrdmg3zdqiz86j43dygykbyz0987lyqxam";
  };

  # Needs `libblkid' and `libcomerr' from `e2fsprogs' or `util-linux-ng'.
  buildInputs = [ tcpWrapper utillinuxng libcap ];

  # FIXME: Add the dependencies needed for NFSv4 and TI-RPC.
  configureFlags =
    [ "--disable-gss" "--disable-nfsv4" "--disable-nfsv41" "--disable-tirpc"
      "--with-statedir=/var/lib/nfs"
    ]
    ++ stdenv.lib.optional (stdenv ? glibc) "--with-rpcgen=${stdenv.glibc}/bin/rpcgen";

  patchPhase =
    ''
      for i in "tests/"*.sh
      do
        sed -i "$i" -e's|/bin/bash|/bin/sh|g'
        chmod +x "$i"
      done
      sed -i s,/usr/sbin,$out/sbin, utils/statd/statd.c
    '';

  preBuild =
    ''
      makeFlags="sbindir=$out/sbin"
      installFlags="statedir=$TMPDIR" # hack to make `make install' work
    '';

  # One test fails on mips.
  doCheck = if stdenv.isMips then false else true;

  meta = {
    description = "Linux user-space NFS utilities";

    longDescription = ''
      This package contains various Linux user-space Network File
      System (NFS) utilities, including RPC `mount' and `nfs'
      daemons.
    '';

    homepage = http://nfs.sourceforge.net/;
    license = "GPLv2";

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
