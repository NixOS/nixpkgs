{ stdenv, fetchurl, fetchpatch, lib, pkg-config, util-linux, libcap, libtirpc, libevent
, sqlite, libkrb5, kmod, libuuid, keyutils, lvm2, systemd, coreutils, tcp_wrappers
, python3, buildPackages, nixosTests, rpcsvc-proto
, enablePython ? true
}:

let
  statdPath = lib.makeBinPath [ systemd util-linux coreutils ];
in

stdenv.mkDerivation rec {
  pname = "nfs-utils";
  version = "2.6.2";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/nfs-utils/${version}/${pname}-${version}.tar.xz";
    hash = "sha256-UgCHPoHE1hDiRi/CYv4YE18tvni3l5+VrM0VmuZNUBE=";
  };

  # libnfsidmap is built together with nfs-utils from the same source,
  # put it in the "lib" output, and the headers in "dev"
  outputs = [ "out" "dev" "lib" "man" ];

  nativeBuildInputs = [ pkg-config buildPackages.stdenv.cc rpcsvc-proto ];

  buildInputs = [
    libtirpc libcap libevent sqlite lvm2
    libuuid keyutils libkrb5 tcp_wrappers
  ] ++ lib.optional enablePython python3;

  enableParallelBuilding = true;

  preConfigure =
    ''
      substituteInPlace configure \
        --replace '$dir/include/gssapi' ${lib.getDev libkrb5}/include/gssapi \
        --replace '$dir/bin/krb5-config' ${lib.getDev libkrb5}/bin/krb5-config
    '';

  configureFlags =
    [ "--enable-gss"
      "--enable-svcgss"
      "--with-statedir=/var/lib/nfs"
      "--with-krb5=${lib.getLib libkrb5}"
      "--with-systemd=${placeholder "out"}/etc/systemd/system"
      "--enable-libmount-mount"
      "--with-pluginpath=${placeholder "lib"}/lib/libnfsidmap" # this installs libnfsidmap
      "--with-rpcgen=${buildPackages.rpcsvc-proto}/bin/rpcgen"
      "--with-modprobedir=${placeholder "out"}/etc/modprobe.d"
    ];

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

      substituteInPlace tools/nfsrahead/Makefile.in \
        --replace "/usr/lib/udev/rules.d/" "$out/lib/udev/rules.d/"

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
    '' + lib.optionalString (!enablePython) ''
      # Remove all scripts that require python (currently mountstats and nfsiostat)
      grep -l /usr/bin/python $out/bin/* | xargs -I {} rm -v {}
    '';

  # One test fails on mips.
  # doCheck = !stdenv.isMips;
  # https://bugzilla.kernel.org/show_bug.cgi?id=203793
  doCheck = false;

  disallowedReferences = [ (lib.getDev libkrb5) ];

  passthru.tests = {
    nfs3-simple = nixosTests.nfs3.simple;
    nfs4-simple = nixosTests.nfs4.simple;
    nfs4-kerberos = nixosTests.nfs4.kerberos;
  };

  meta = with lib; {
    description = "Linux user-space NFS utilities";

    longDescription = ''
      This package contains various Linux user-space Network File
      System (NFS) utilities, including RPC `mount' and `nfs'
      daemons.
    '';

    homepage = "https://linux-nfs.org/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
