{ fetchurl, stdenv, tcp_wrappers, utillinux, libcap, libtirpc, libevent, libnfsidmap
, lvm2, e2fsprogs, python, sqlite
}:

stdenv.mkDerivation rec {
  name = "nfs-utils-1.3.2";

  src = fetchurl {
    url = "mirror://sourceforge/nfs/${name}.tar.bz2";
    sha256 = "1xwilpdr1vizq2yhpzxpwqqr9f8kn0dy2wcpc626mf30ybp7572v";
  };

  buildInputs =
    [ tcp_wrappers utillinux libcap libtirpc libevent libnfsidmap
      lvm2 e2fsprogs python sqlite
    ];

  # FIXME: Add the dependencies needed for NFSv4 and TI-RPC.
  configureFlags =
    [ "--disable-gss"
      "--with-statedir=/var/lib/nfs"
      "--with-tirpcinclude=${libtirpc}/include/tirpc"
    ]
    ++ stdenv.lib.optional (stdenv ? glibc) "--with-rpcgen=${stdenv.glibc}/bin/rpcgen";

  patches = [ ./no-install.patch ];

  postPatch = ''
    for i in "tests/"*.sh
    do
      sed -i "$i" -e's|/bin/bash|/bin/sh|g'
      chmod +x "$i"
    done
    sed -i s,/usr/sbin,$out/sbin, utils/statd/statd.c
  '';

  preBuild = ''
    makeFlags="sbindir=$out/sbin"
    installFlags="statedir=$TMPDIR" # hack to make `make install' work
  '';

  # One test fails on mips.
  doCheck = !stdenv.isMips;

  meta = {
    description = "Linux user-space NFS utilities";

    longDescription = ''
      This package contains various Linux user-space Network File
      System (NFS) utilities, including RPC `mount' and `nfs'
      daemons.
    '';

    homepage = http://nfs.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2;

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ ];
  };
}
