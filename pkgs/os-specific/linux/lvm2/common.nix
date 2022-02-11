{ version, sha256 }:

{ lib, stdenv
, fetchpatch
, fetchurl
, pkg-config
, util-linux
, libuuid
, libaio
, enableCmdlib ? false
, enableDmeventd ? false
, udevSupport ? !stdenv.targetPlatform.isStatic, udev ? null
, onlyLib ? stdenv.targetPlatform.isStatic
, nixosTests
}:

# configure: error: --enable-dmeventd requires --enable-cmdlib to be used as well
assert enableDmeventd -> enableCmdlib;

stdenv.mkDerivation rec {
  pname = "lvm2" + lib.optionalString enableDmeventd "-with-dmeventd";
  inherit version;

  src = fetchurl {
    url = "https://mirrors.kernel.org/sourceware/lvm2/LVM2.${version}.tgz";
    inherit sha256;
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libaio
  ] ++ lib.optionals udevSupport [
    udev
  ] ++ lib.optionals (!onlyLib) [
    libuuid
  ];

  configureFlags = [
    "--disable-readline"
    "--enable-pkgconfig"
    "--with-default-locking-dir=/run/lock/lvm"
    "--with-default-run-dir=/run/lvm"
    "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
  ] ++ lib.optionals (!enableCmdlib) [
    "--bindir=${placeholder "bin"}/bin"
    "--sbindir=${placeholder "bin"}/bin"
    "--libdir=${placeholder "lib"}/lib"
  ] ++ lib.optional enableCmdlib "--enable-cmdlib"
  ++ lib.optionals enableDmeventd [
    "--enable-dmeventd"
    "--with-dmeventd-pidfile=/run/dmeventd/pid"
    "--with-default-dm-run-dir=/run/dmeventd"
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "ac_cv_func_malloc_0_nonnull=yes"
    "ac_cv_func_realloc_0_nonnull=yes"
  ] ++ lib.optionals udevSupport [
    "--enable-udev_rules"
    "--enable-udev_sync"
  ] ++ lib.optionals stdenv.targetPlatform.isStatic [
    "--enable-static_link"
  ];

  preConfigure = ''
    sed -i /DEFAULT_SYS_DIR/d Makefile.in
    sed -i /DEFAULT_PROFILE_DIR/d conf/Makefile.in
    substituteInPlace scripts/lvm2_activation_generator_systemd_red_hat.c \
      --replace /usr/bin/udevadm /run/current-system/systemd/bin/udevadm
    # https://github.com/lvmteam/lvm2/issues/36
  '' + lib.optionalString (lib.versionOlder version "2.03.14") ''
    substituteInPlace udev/69-dm-lvm-metad.rules.in \
      --replace "(BINDIR)/systemd-run" /run/current-system/systemd/bin/systemd-run
  '' + lib.optionalString (lib.versionAtLeast version "2.03.14") ''
    substituteInPlace udev/69-dm-lvm.rules.in \
      --replace "/usr/bin/systemd-run" /run/current-system/systemd/bin/systemd-run
  '' + ''
    substituteInPlace make.tmpl.in --replace "@systemdsystemunitdir@" "$out/lib/systemd/system"
  '' + lib.optionalString (lib.versionAtLeast version "2.03") ''
    substituteInPlace libdm/make.tmpl.in --replace "@systemdsystemunitdir@" "$out/lib/systemd/system"
  '';

  postConfigure = ''
    sed -i 's|^#define LVM_CONFIGURE_LINE.*$|#define LVM_CONFIGURE_LINE "<removed>"|g' ./include/configure.h
  '';

  patches = [
    # Musl fixes from Alpine.
    ./fix-stdio-usage.patch
    (fetchpatch {
      name = "mallinfo.patch";
      url = "https://git.alpinelinux.org/aports/plain/main/lvm2/mallinfo.patch?h=3.7-stable&id=31bd4a8c2dc00ae79a821f6fe0ad2f23e1534f50";
      sha256 = "0g6wlqi215i5s30bnbkn8w7axrs27y3bnygbpbnf64wwx7rxxlj0";
    })
  ] ++ lib.optionals stdenv.targetPlatform.isStatic [
    ./no-shared.diff
  ];

  doCheck = false; # requires root

  makeFlags = lib.optionals udevSupport [
    "SYSTEMD_GENERATOR_DIR=$(out)/lib/systemd/system-generators"
  ] ++ lib.optionals onlyLib [
    "libdm.device-mapper"
  ];

  # To prevent make install from failing.
  installFlags = [ "OWNER=" "GROUP=" "confdir=$(out)/etc" ];

  # Install systemd stuff.
  installTargets = [ "install" ] ++ lib.optionals udevSupport [
    "install_systemd_generators"
    "install_systemd_units"
    "install_tmpfiles_configuration"
  ];

  installPhase = lib.optionalString onlyLib ''
    install -D -t $out/lib libdm/ioctl/libdevmapper.${if stdenv.targetPlatform.isStatic then "a" else "so"}
    make -C libdm install_include
    make -C libdm install_pkgconfig
  '';

  # only split bin and lib out from out if cmdlib isn't enabled
  outputs = [
    "out"
  ] ++ lib.optionals (!onlyLib) [
    "dev"
    "man"
  ] ++ lib.optionals (!onlyLib && !enableCmdlib) [
    "bin"
    "lib"
  ];

  postInstall = lib.optionalString (enableCmdlib != true) ''
    moveToOutput lib/libdevmapper.so $lib
  '';

  passthru.tests.installer = nixosTests.installer.lvm;

  meta = with lib; {
    homepage = "http://sourceware.org/lvm2/";
    description = "Tools to support Logical Volume Management (LVM) on Linux";
    platforms = platforms.linux;
    license = with licenses; [ gpl2 bsd2 lgpl21 ];
    maintainers = with maintainers; [ raskin ajs124 ];
  };
}
