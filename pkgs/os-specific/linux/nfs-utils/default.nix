{ stdenv, fetchurl, lib, pkgconfig, utillinux, libcap, libtirpc, libevent, libnfsidmap
, sqlite, kerberos, kmod, libuuid, keyutils, lvm2, systemd, coreutils, tcp_wrappers
}:

let
  statdPath = lib.makeBinPath [ systemd utillinux coreutils ];

in stdenv.mkDerivation rec {
  name = "nfs-utils-${version}";
  version = "2.1.1";

  src = fetchurl {
    url = "mirror://sourceforge/nfs/${name}.tar.bz2";
    sha256 = "02dvxphndpm8vpqqnl0zvij97dq9vsq2a179pzrjcv2i91ll2a0a";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [
    libtirpc libcap libevent libnfsidmap sqlite lvm2
    libuuid keyutils kerberos tcp_wrappers
  ];

  enableParallelBuilding = true;

  configureFlags =
    [ "--enable-gss"
      "--with-statedir=/var/lib/nfs"
      "--with-krb5=${kerberos}"
      "--with-systemd=$(out)/etc/systemd/system"
      "--enable-libmount-mount"
    ]
    ++ lib.optional (stdenv ? glibc) "--with-rpcgen=${stdenv.glibc.bin}/bin/rpcgen";

  postPatch =
    ''
      patchShebangs tests
      sed -i "s,/usr/sbin,$out/bin,g" utils/statd/statd.c
      sed -i "s,^PATH=.*,PATH=$out/bin:${statdPath}," utils/statd/start-statd

      configureFlags="--with-start-statd=$out/bin/start-statd $configureFlags"
      
      substituteInPlace systemd/nfs-utils.service \
        --replace "/bin/true" "${coreutils}/bin/true"

      substituteInPlace utils/mount/Makefile.in \
        --replace "chmod 4511" "chmod 0511"
    '';

  makeFlags = [
    "sbindir=$(out)/bin"
    "generator_dir=$(out)/etc/systemd/system-generators"
  ];

  installFlags = [
    "statedir=$(TMPDIR)"
    "statdpath=$(TMPDIR)"
  ];

  postInstall =
    ''
      # Not used on NixOS
      sed -i \
        -e "s,/sbin/modprobe,${kmod}/bin/modprobe,g" \
        -e "s,/usr/sbin,$out/bin,g" \
        $out/etc/systemd/system/*
    '';

  # One test fails on mips.
  doCheck = !stdenv.isMips;

  meta = with stdenv.lib; {
    description = "Linux user-space NFS utilities";

    longDescription = ''
      This package contains various Linux user-space Network File
      System (NFS) utilities, including RPC `mount' and `nfs'
      daemons.
    '';

    homepage = "https://sourceforge.net/projects/nfs/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
