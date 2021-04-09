{ lib, stdenv
, fetchpatch
, fetchurl
, pkg-config
, util-linux
, libuuid
, thin-provisioning-tools, libaio
, enableCmdlib ? false
, enableDmeventd ? false
, udev ? null
, nixosTests
}:

# configure: error: --enable-dmeventd requires --enable-cmdlib to be used as well
assert enableDmeventd -> enableCmdlib;

stdenv.mkDerivation rec {
  pname = "lvm2" + lib.optionalString enableDmeventd "with-dmeventd";
  version = "2.03.11";

  src = fetchurl {
    url = "https://mirrors.kernel.org/sourceware/lvm2/LVM2.${version}.tgz";
    sha256 = "1m4xpda8vbyd89ca0w8nacvnl4j34yzsa625gn990fb5sh84ab44";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libuuid thin-provisioning-tools libaio ]
                ++ lib.optional (!stdenv.hostPlatform.isMusl) udev;

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
  ] ++
  lib.optionals (!stdenv.hostPlatform.isMusl && udev != null) [
    "--enable-udev_rules"
    "--enable-udev_sync"
  ];

  preConfigure = ''
    sed -i /DEFAULT_SYS_DIR/d Makefile.in
    sed -i /DEFAULT_PROFILE_DIR/d conf/Makefile.in
    substituteInPlace scripts/lvm2_activation_generator_systemd_red_hat.c \
      --replace /usr/bin/udevadm /run/current-system/systemd/bin/udevadm
    # https://github.com/lvmteam/lvm2/issues/36
    substituteInPlace udev/69-dm-lvm-metad.rules.in \
      --replace "(BINDIR)/systemd-run" /run/current-system/systemd/bin/systemd-run

    substituteInPlace make.tmpl.in --replace "@systemdsystemunitdir@" "$out/lib/systemd/system"
    substituteInPlace libdm/make.tmpl.in --replace "@systemdsystemunitdir@" "$out/lib/systemd/system"
  '';

  postConfigure = ''
    sed -i 's|^#define LVM_CONFIGURE_LINE.*$|#define LVM_CONFIGURE_LINE "<removed>"|g' ./include/configure.h
  '';


  patches = let
    # you can get the latest commit id from here: https://git.alpinelinux.org/aports/log/
    version = "eae8e06eee6e93e59139cf4d06e8414f681e20c9";
  in [
    (fetchpatch {
      name = "fix-stdio-usage.patch";
      url = "https://git.alpinelinux.org/aports/plain/main/lvm2/fix-stdio-usage.patch?id=${version}";
      sha256 = "sha256-YNKMmyrbK69N9uGMP+sJ4CMhOqCxthZ/Fg8O+1jMSWI=";
    })
    (fetchpatch {
      name = "mallinfo.patch";
      url = "https://git.alpinelinux.org/aports/plain/main/lvm2/mallinfo.patch?id=${version}";
      sha256 = "sha256-QNLe8+mcE+Psuut5u4Y/QueuDkd2LrvA0CWWICKm3Dw=";
    })
  ];

  doCheck = false; # requires root

  makeFlags = [
    "SYSTEMD_GENERATOR_DIR=$(out)/lib/systemd/system-generators"
  ];

  # To prevent make install from failing.
  installFlags = [ "OWNER=" "GROUP=" "confdir=$(out)/etc" ];

  # Install systemd stuff.
  installTargets = [ "install" ] ++ lib.optionals (!stdenv.hostPlatform.isMusl && udev != null) [
    "install_systemd_generators"
    "install_systemd_units"
    "install_tmpfiles_configuration"
  ];

  # only split bin and lib out from out if cmdlib isn't enabled
  outputs = [
    "out"
    "dev"
    "man"
  ] ++ lib.optionals (enableCmdlib != true) [
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
