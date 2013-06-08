{ fetchurl, stdenv, tcp_wrappers, utillinux, libcap, libtirpc, libevent, libnfsidmap
, lvm2, e2fsprogs }:

stdenv.mkDerivation rec {
  name = "nfs-utils-1.2.5";

  src = fetchurl {
    url = "mirror://sourceforge/nfs/${name}.tar.bz2";
    sha256 = "16ssfkj36ljifyaskgwpd3ys8ylhi5gasq88aha3bhg5dr7yv59m";
  };

  buildInputs =
    [ tcp_wrappers utillinux libcap libtirpc libevent libnfsidmap
      lvm2 e2fsprogs
    ];

  # FIXME: Add the dependencies needed for NFSv4 and TI-RPC.
  configureFlags =
    [ "--disable-gss"
      "--with-statedir=/var/lib/nfs"
      "--with-tirpcinclude=${libtirpc}/include/tirpc"
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

      # https://bugzilla.redhat.com/show_bug.cgi?id=749195
      sed -i s,PAGE_SIZE,getpagesize\(\), utils/blkmapd/device-process.c
    '';

  preBuild =
    ''
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
    license = "GPLv2";

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
