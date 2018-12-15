{ stdenv, fetchurl, fetchpatch, lib, pkgconfig, utillinux, libcap, libtirpc, libevent
, sqlite, kerberos, kmod, libuuid, keyutils, lvm2, systemd, coreutils, tcp_wrappers
, buildEnv, python3
}:

let
  statdPath = lib.makeBinPath [ systemd utillinux coreutils ];
in

stdenv.mkDerivation rec {
  name = "nfs-utils-${version}";
  version = "2.3.3";

  src = fetchurl {
    url = "https://kernel.org/pub/linux/utils/nfs-utils/${version}/${name}.tar.xz";
    sha256 = "08k36d7l8yqylscnln3p85lcfwi7r7g6n3bnslgmzc1i71wk92zn";
  };

  # libnfsidmap is built together with nfs-utils from the same source,
  # put it in the "lib" output, and the headers in "dev"
  outputs = [ "out" "dev" "lib" "man" ];

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [
    libtirpc libcap libevent sqlite lvm2
    libuuid keyutils kerberos tcp_wrappers
    python3
  ];

  enableParallelBuilding = true;

  preConfigure =
    ''
      substituteInPlace configure \
        --replace '$dir/include/gssapi' ${lib.getDev kerberos}/include/gssapi \
        --replace '$dir/bin/krb5-config' ${lib.getDev kerberos}/bin/krb5-config
    '';

  #configureScript = "bash -x configure";

  configureFlags =
    [ "--enable-gss"
      "--with-statedir=/var/lib/nfs"
      "--with-krb5=${lib.getLib kerberos}"
      "--with-systemd=${placeholder "out"}/etc/systemd/system"
      "--enable-libmount-mount"
      "--with-pluginpath=${placeholder "lib"}/lib/libnfsidmap" # this installs libnfsidmap
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

  stripDebugList = [ "lib" "libexec" "bin" "etc/systemd/system-generators" ];

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

  disallowedReferences = [ (lib.getDev kerberos) ];

  meta = with stdenv.lib; {
    description = "Linux user-space NFS utilities";

    longDescription = ''
      This package contains various Linux user-space Network File
      System (NFS) utilities, including RPC `mount' and `nfs'
      daemons.
    '';

    homepage = https://linux-nfs.org/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
