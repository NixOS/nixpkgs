{ stdenv, fetchurl, fetchpatch, lib, pkgconfig, utillinux, libcap, libtirpc, libevent, libnfsidmap
, sqlite, kerberos, kmod, libuuid, keyutils, lvm2, systemd, coreutils, tcp_wrappers
, buildEnv
}:

let
  statdPath = lib.makeBinPath [ systemd utillinux coreutils ];

  # Not nice; feel free to find a nicer solution.
  kerberosEnv = buildEnv {
    name = "kerberos-env-${kerberos.version}";
    paths = with lib; [ (getDev kerberos) (getLib kerberos) ];
  };

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
      "--with-krb5=${kerberosEnv}"
      "--with-systemd=$(out)/etc/systemd/system"
      "--enable-libmount-mount"
    ]
    ++ lib.optional (stdenv ? glibc) "--with-rpcgen=${stdenv.glibc.bin}/bin/rpcgen";

  patches = lib.optionals stdenv.hostPlatform.isMusl [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/alpinelinux/aports/cb880042d48d77af412d4688f24b8310ae44f55f/main/nfs-utils/0011-exportfs-only-do-glibc-specific-hackery-on-glibc.patch";
      sha256 = "0rrddrykz8prk0dcgfvmnz0vxn09dbgq8cb098yjjg19zz6d7vid";
    })
    # http://openwall.com/lists/musl/2015/08/18/10
    (fetchpatch {
      url = "https://raw.githubusercontent.com/alpinelinux/aports/cb880042d48d77af412d4688f24b8310ae44f55f/main/nfs-utils/musl-getservbyport.patch";
      sha256 = "1fqws9dz8n1d9a418c54r11y3w330qgy2652dpwcy96cm44sqyhf";
    })
  ];

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

      sed '1i#include <stdint.h>' -i support/nsm/rpc.c
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

    homepage = https://sourceforge.net/projects/nfs/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
