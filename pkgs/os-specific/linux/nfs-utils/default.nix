{ fetchurl, stdenv, tcpWrapper, utillinuxng, libcap }:

stdenv.mkDerivation rec {
  name = "nfs-utils-1.2.2";

  src = fetchurl {
    url = "mirror://sourceforge/nfs/${name}.tar.bz2";
    sha256 = "07nhr7ds5ic4x81l9qphrlmi4ifxl28xzr1zpzvg334ncrv2fizx";
  };

  # Needs `libblkid' and `libcomerr' from `e2fsprogs' or `util-linux-ng'.
  buildInputs = [ tcpWrapper utillinuxng libcap ];

  # FIXME: Add the dependencies needed for NFSv4 and TI-RPC.
  configureFlags =
    [ "--disable-gss" "--disable-nfsv4" "--disable-nfsv41" "--disable-tirpc"
      "--with-statedir=/var/lib/nfs"
    ];

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

  doCheck = true;

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
