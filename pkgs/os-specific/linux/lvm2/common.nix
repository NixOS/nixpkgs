{ version, hash }:

{ lib, stdenv
, fetchurl
, pkg-config
, coreutils
, libuuid
, libaio
, substituteAll
, enableCmdlib ? false
, enableDmeventd ? false
, udevSupport ? !stdenv.hostPlatform.isStatic, udev
, onlyLib ? stdenv.hostPlatform.isStatic
  # Otherwise we have a infinity recursion during static compilation
, enableUtilLinux ? !stdenv.hostPlatform.isStatic, util-linux
, enableVDO ? false, vdo
, enableMdadm ? false, mdadm
, enableMultipath ? false, multipath-tools
, nixosTests
}:

# configure: error: --enable-dmeventd requires --enable-cmdlib to be used as well
assert enableDmeventd -> enableCmdlib;

stdenv.mkDerivation rec {
  pname = "lvm2" + lib.optionalString enableDmeventd "-with-dmeventd" + lib.optionalString enableVDO "-with-vdo";
  inherit version;

  src = fetchurl {
    urls = [
      "https://mirrors.kernel.org/sourceware/lvm2/LVM2.${version}.tgz"
      "ftp://sourceware.org/pub/lvm2/LVM2.${version}.tgz"
    ];
    inherit hash;
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libaio
  ] ++ lib.optionals udevSupport [
    udev
  ] ++ lib.optionals (!onlyLib) [
    libuuid
  ] ++ lib.optionals enableVDO [
    vdo
  ];

  configureFlags = [
    "--disable-readline"
    "--enable-pkgconfig"
    "--with-default-locking-dir=/run/lock/lvm"
    "--with-default-run-dir=/run/lvm"
    "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
    "--with-systemd-run=/run/current-system/systemd/bin/systemd-run"
  ] ++ lib.optionals (!enableCmdlib) [
    "--bindir=${placeholder "bin"}/bin"
    "--sbindir=${placeholder "bin"}/bin"
    "--libdir=${placeholder "lib"}/lib"
    "--with-libexecdir=${placeholder "lib"}/libexec"
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
  ] ++ lib.optionals enableVDO [
    "--enable-vdo"
  ] ++ lib.optionals stdenv.hostPlatform.isStatic [
    "--enable-static_link"
  ];

  preConfigure = ''
    sed -i /DEFAULT_SYS_DIR/d Makefile.in
    sed -i /DEFAULT_PROFILE_DIR/d conf/Makefile.in

    substituteInPlace make.tmpl.in --replace "@systemdsystemunitdir@" "$out/lib/systemd/system"
    substituteInPlace libdm/make.tmpl.in --replace "@systemdsystemunitdir@" "$out/lib/systemd/system"

    substituteInPlace scripts/blk_availability_systemd_red_hat.service.in \
      --replace '/usr/bin/true' '${coreutils}/bin/true'
  '';

  postConfigure = ''
    sed -i 's|^#define LVM_CONFIGURE_LINE.*$|#define LVM_CONFIGURE_LINE "<removed>"|g' ./include/configure.h
  '';

  patches = [
    # fixes paths to and checks for tools
    (substituteAll (let
      optionalTool = cond: pkg: if cond then pkg else "/run/current-system/sw";
    in {
      src = ./fix-blkdeactivate.patch;
      inherit coreutils;
      util_linux = optionalTool enableUtilLinux util-linux;
      mdadm = optionalTool enableMdadm mdadm;
      multipath_tools = optionalTool enableMultipath multipath-tools;
      vdo = optionalTool enableVDO vdo;
    }))
    # Musl fix from Alpine
    ./fix-stdio-usage.patch
  ] ++ lib.optionals stdenv.hostPlatform.isStatic [
    ./no-shared.patch
  ];

  doCheck = false; # requires root

  makeFlags = lib.optionals udevSupport [
    "SYSTEMD_GENERATOR_DIR=${placeholder "out"}/lib/systemd/system-generators"
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
    install -D -t $out/lib libdm/ioctl/libdevmapper.${if stdenv.hostPlatform.isStatic then "a" else "so"}
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

  passthru.tests = {
    installer = nixosTests.installer.lvm;
    lvm2 = nixosTests.lvm2;
  };

  meta = with lib; {
    homepage = "http://sourceware.org/lvm2/";
    description = "Tools to support Logical Volume Management (LVM) on Linux";
    platforms = platforms.linux;
    license = with licenses; [ gpl2 bsd2 lgpl21 ];
    maintainers = with maintainers; [ raskin ] ++ teams.helsinki-systems.members;
  };
}
