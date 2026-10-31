{
  mkDerivation,
  stdenv,
  buildPackages,
  pkgsBuildTarget,
}:

mkDerivation {
  path = "sys/arch/amd64/stand";
  extraPaths = [ "sys" ];

  patches = [
    ../sys/initpath.patch
    ../cmd-buff-size.patch
  ];

  # gcc compat
  postPatch = ''
    find $BSDSRCDIR -name Makefile -print0 | xargs -0 sed -E -i -e 's/-nopie/-no-pie/g'

    # These host utilities require OpenBSD base libraries and are not installed.
    substituteInPlace $BSDSRCDIR/sys/arch/amd64/stand/Makefile \
      --replace-fail 'SUBDIR+=rdboot vmboot' ""

    # lld requires an explicit zero image base for boot code linked below its
    # default image base.
    substituteInPlace \
      $BSDSRCDIR/sys/arch/amd64/stand/{mbr,biosboot}/Makefile \
      --replace-fail '-Ttext 0' '-Ttext 0 --image-base=0'
    substituteInPlace \
      $BSDSRCDIR/sys/arch/amd64/stand/{boot,cdboot,pxeboot}/Makefile \
      --replace-fail '-Ttext $(LINKADDR)' '-Ttext $(LINKADDR) --image-base=0'
    substituteInPlace $BSDSRCDIR/sys/arch/amd64/stand/cdbr/Makefile \
      --replace-fail '-Ttext ''${ORG}' '-Ttext ''${ORG} --image-base=0'

    # LLVM objcopy reads the lld-produced ELF image, then GNU objcopy converts
    # it to the PE format used by EFI.
    substituteInPlace $BSDSRCDIR/sys/arch/amd64/stand/efiboot/Makefile.common \
      --replace-fail '    --target=''${OBJFMT} ''${PROG.so} ''${.TARGET}' \
        '    --input-target=''${INPUTFMT} --output-target=''${OBJFMT} --subsystem=efi-app ''${PROG.so}.elf ''${.TARGET}'
    sed -i '/^''${PROG}: ''${PROG.so}$/a\	''${LLVM_OBJCOPY} --output-target=''${INPUTFMT} ''${PROG.so} ''${PROG.so}.elf' \
      $BSDSRCDIR/sys/arch/amd64/stand/efiboot/Makefile.common
    substituteInPlace $BSDSRCDIR/sys/arch/amd64/stand/efiboot/bootx64/Makefile \
      --replace-fail 'OBJFMT=		efi-app-x86_64' \
        $'OBJFMT=\t\tpei-x86-64\nINPUTFMT=\telf64-x86-64'
    substituteInPlace $BSDSRCDIR/sys/arch/amd64/stand/efiboot/bootia32/Makefile \
      --replace-fail 'OBJFMT=		efi-app-ia32' \
        $'OBJFMT=\t\tpei-i386\nINPUTFMT=\telf32-i386'
    substituteInPlace $BSDSRCDIR/sys/arch/*/stand/boot/check-boot.pl --replace-fail /usr/bin/objdump objdump
    substituteInPlace $BSDSRCDIR/sys/arch/*/stand/Makefile --replace-quiet " boot " " " --replace-quiet " fdboot " " "
  '';

  # expects to be able to use unprefixed programs
  # needs gnu assembler + objdump + objcopy
  # this is really not designed for cross...
  preBuild = ''
    mkdir $TMP/bin
    export PATH=$TMP/bin:$PATH
    ln -s ${stdenv.cc}/bin/${stdenv.cc.targetPrefix}size $TMP/bin/size
    ln -s ${pkgsBuildTarget.binutils}/bin/${pkgsBuildTarget.binutils.targetPrefix}as $TMP/bin/as
    ln -s ${pkgsBuildTarget.binutils}/bin/${pkgsBuildTarget.binutils.targetPrefix}objdump $TMP/bin/objdump
    ln -s ${pkgsBuildTarget.binutils}/bin/${pkgsBuildTarget.binutils.targetPrefix}objcopy $TMP/bin/objcopy
    ln -s ${pkgsBuildTarget.binutils}/bin/${pkgsBuildTarget.binutils.targetPrefix}objcopy $TMP/bin/

    export OBJCOPY="${buildPackages.binutils-unwrapped-all-targets}/bin/${stdenv.cc.targetPrefix}objcopy"
    export LLVM_OBJCOPY="${buildPackages.llvmPackages.llvm}/bin/llvm-objcopy"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -Wno-pointer-sign"
  '';
}
