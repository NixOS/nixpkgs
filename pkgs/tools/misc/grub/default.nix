{
  lib,
  stdenv,
  fetchurl,
  flex,
  bison,
  python3,
  autoconf,
  autoconf-archive,
  automake,
  autoreconfHook,
  libtool,
  bash,
  gettext,
  ncurses,
  libusb-compat-0_1,
  freetype,
  qemu,
  lvm2,
  unifont,
  pkg-config,
  help2man,
  fetchzip,
  fetchpatch,
  buildPackages,
  nixosTests,
  fuse, # only needed for grub-mount
  xz, # for xz compression support. Usually counterproductive, so don't try to force compression in your GRUB install.
  runtimeShell,
  zfs ? null,
  efiSupport ? false,
  ieee1275Support ? false,
  zfsSupport ? false,
  xenSupport ? false,
  xenPvhSupport ? false,
  corebootSupport ? false,
  kbdcompSupport ? corebootSupport,
  ckbcomp,
}:

let
  pcSystems = {
    i686-linux.target = "i386";
    x86_64-linux.target = "i386";
  };

  efiSystemsBuild = {
    i686-linux.target = "i386";
    x86_64-linux.target = "x86_64";
    armv7l-linux.target = "arm";
    aarch64-linux.target = "aarch64";
    loongarch64-linux.target = "loongarch64";
    riscv32-linux.target = "riscv32";
    riscv64-linux.target = "riscv64";
  };

  # For aarch64, we need to use '--target=aarch64-efi' when building,
  # but '--target=arm64-efi' when installing. Insanity!
  efiSystemsInstall = {
    i686-linux.target = "i386";
    x86_64-linux.target = "x86_64";
    armv7l-linux.target = "arm";
    aarch64-linux.target = "arm64";
    loongarch64-linux.target = "loongarch64";
    riscv32-linux.target = "riscv32";
    riscv64-linux.target = "riscv64";
  };

  ieee1275SystemsBuild = {
    x86_64-linux.target = "i386";
    powerpc64-linux.target = "powerpc";
  };

  xenSystemsBuild = {
    i686-linux.target = "i386";
    x86_64-linux.target = "x86_64";
  };

  xenPvhSystemsBuild = {
    i686-linux.target = "i386";
    x86_64-linux.target = "i386"; # Xen PVH is only i386 on x86.
  };

  inPCSystems = lib.any (system: stdenv.hostPlatform.system == system) (lib.attrNames pcSystems);
in

assert zfsSupport -> zfs != null;
assert lib.asserts.assertMsg (
  lib.lists.length (
    lib.lists.filter (x: x) [
      efiSupport
      ieee1275Support
      xenSupport
      xenPvhSupport
      corebootSupport
    ]
  ) <= 1 # (0 == pc)
) "Only <= 1 of grub2's platform-related *Support options may be enabled at the same time";

stdenv.mkDerivation rec {
  pname = "grub";
  version = "2.14";

  src = fetchurl {
    url = "mirror://gnu/grub/grub-${version}.tar.xz";
    hash = "sha256-vI08c1NbiDjYyOJlTXPtxOaujIrNtF1d9dyaFUdEbUM=";
  };

  patches = [
    ./fix-bash-completion.patch
    ./add-hidden-menu-entries.patch

    /*
      The commit that we're reverting below breaks the `kernel.img` payload that's generated at runtime.

      If we don't do this, we can't install GRUB.
    */
    (fetchpatch {
      name = "01_fix_kernel-img_load_offset.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=1a5417f39a0ccefcdd5440f2a67f84d2d2e26960";
      revert = true;
      hash = "sha256-mHaVrzGs7uqYqSSAHOw1qgZSHLWG3CmVcZWrSLvVOy8=";
    })
    (fetchpatch {
      name = "00_fix_kernel-img_load_offset.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=ac042f3f58d33ce9cd5ff61750f06da1a1d7b0eb";
      revert = true;
      hash = "sha256-uYlS4r0frL62H35Bts+W9l4MOHCcoBGOhbCQtxU363s=";
    })
  ];

  postPatch =
    if kbdcompSupport then
      ''
        sed -i util/grub-kbdcomp.in -e 's@\bckbcomp\b@${ckbcomp}/bin/ckbcomp@'
      ''
    else
      ''
        echo '#! ${runtimeShell}' > util/grub-kbdcomp.in
        echo 'echo "Compile grub2 with { kbdcompSupport = true; } to enable support for this command."' >> util/grub-kbdcomp.in
      '';

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [
    bison
    flex
    python3
    pkg-config
    gettext
    freetype
    autoconf
    autoconf-archive
    autoreconfHook
    automake
    help2man
  ];
  buildInputs = [
    ncurses
    libusb-compat-0_1
    freetype
    lvm2
    fuse
    xz
    libtool
    bash
  ]
  ++ lib.optional doCheck qemu
  ++ lib.optional zfsSupport zfs;

  strictDeps = true;

  hardeningDisable = [ "all" ];

  separateDebugInfo = !xenSupport;

  preConfigure = ''
    for i in "tests/util/"*.in
    do
      sed -i "$i" -e's|/bin/bash|${stdenv.shell}|g'
    done

    # Apparently, the QEMU executable is no longer called
    # `qemu-system-i386', even on i386.
    #
    # In addition, use `-nodefaults' to avoid errors like:
    #
    #  chardev: opening backend "stdio" failed
    #  qemu: could not open serial device 'stdio': Invalid argument
    #
    # See <http://www.mail-archive.com/qemu-devel@nongnu.org/msg22775.html>.
    sed -i "tests/util/grub-shell.in" \
        -e's/qemu-system-i386/qemu-system-x86_64 -nodefaults/g'

    substituteInPlace ./configure --replace-fail '/usr/share/fonts/unifont' '${unifont}/share/fonts'
  '';

  configureFlags = [
    "--enable-grub-mount" # dep of os-prober
  ]
  ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    # grub doesn't do cross-compilation as usual and tries to use unprefixed
    # tools to target the host. Provide toolchain information explicitly for
    # cross builds.
    #
    # Ref: # https://github.com/buildroot/buildroot/blob/master/boot/grub2/grub2.mk#L108
    "TARGET_CC=${stdenv.cc.targetPrefix}cc"
    "TARGET_NM=${stdenv.cc.targetPrefix}nm"
    "TARGET_OBJCOPY=${stdenv.cc.targetPrefix}objcopy"
    "TARGET_RANLIB=${stdenv.cc.targetPrefix}ranlib"
    "TARGET_STRIP=${stdenv.cc.targetPrefix}strip"
  ]
  ++ lib.optional zfsSupport "--enable-libzfs"
  ++ lib.optionals efiSupport [
    "--with-platform=efi"
    "--target=${efiSystemsBuild.${stdenv.hostPlatform.system}.target}"
    "--program-prefix="
  ]
  ++ lib.optionals ieee1275Support [
    "--with-platform=ieee1275"
    "--target=${ieee1275SystemsBuild.${stdenv.hostPlatform.system}.target}"
  ]
  ++ lib.optionals xenSupport [
    "--with-platform=xen"
    "--target=${xenSystemsBuild.${stdenv.hostPlatform.system}.target}"
  ]
  ++ lib.optionals xenPvhSupport [
    "--with-platform=xen_pvh"
    "--target=${xenPvhSystemsBuild.${stdenv.hostPlatform.system}.target}"
  ]
  ++ lib.optionals corebootSupport [
    "--with-platform=coreboot"
    "--enable-boot-time" # Log boot times. Might be useful for debugging loading issues.
  ];

  # save target that grub is compiled for
  grubTarget =
    if efiSupport then
      "${efiSystemsInstall.${stdenv.hostPlatform.system}.target}-efi"
    else if ieee1275Support then
      "${ieee1275SystemsBuild.${stdenv.hostPlatform.system}.target}-ieee1275"
    else
      lib.optionalString inPCSystems "${pcSystems.${stdenv.hostPlatform.system}.target}-pc";

  doCheck = false;
  enableParallelBuilding = true;

  postInstall = ''
    ## Although usually referencing store paths is a bad idea, the reference to `gcc` inside grub_target_cppflags seems to be completely harmless.
    #
    ## I am still unsure about the functionality of modinfo.sh, but from what I can tell, it's just metadata.

    patchShebangs $out/lib/grub/*/modinfo.sh
  '';

  passthru.tests = {
    nixos-grub = nixosTests.grub;
    nixos-install-simple = nixosTests.installer.simple;
    nixos-install-grub-uefi = nixosTests.installer.simpleUefiGrub;
    nixos-install-grub-uefi-spec = nixosTests.installer.simpleUefiGrubSpecialisation;
  };

  meta = {
    description = "GNU GRUB, the Grand Unified Boot Loader";

    longDescription = ''
      GNU GRUB is a Multiboot boot loader. It was derived from GRUB, GRand
      Unified Bootloader, which was originally designed and implemented by
      Erich Stefan Boleyn.

      Briefly, the boot loader is the first software program that runs when a
      computer starts.  It is responsible for loading and transferring
      control to the operating system kernel software (such as the Hurd or
      the Linux).  The kernel, in turn, initializes the rest of the
      operating system (e.g., GNU).
    '';

    homepage = "https://www.gnu.org/software/grub/";

    license = lib.licenses.gpl3Plus;

    platforms =
      if efiSupport then
        lib.attrNames efiSystemsBuild
      else if ieee1275Support then
        lib.attrNames ieee1275SystemsBuild
      else if xenSupport then
        lib.attrNames xenSystemsBuild
      else if xenPvhSupport then
        lib.attrNames xenPvhSystemsBuild
      else
        lib.platforms.gnu ++ lib.platforms.linux;

    maintainers = [ ];
  };
}
