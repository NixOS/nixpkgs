{ appleDerivation', lib, stdenv, stdenvNoCC, buildPackages
, bootstrap_cmds, bison, flex
, gnum4, unifdef, perl, python3
, headersOnly ? true
}:

appleDerivation' (if headersOnly then stdenvNoCC else stdenv) (
  let arch = if stdenv.isx86_64 then "x86_64" else "arm64";
  in
  {
  depsBuildBuild = [ buildPackages.stdenv.cc ];

  nativeBuildInputs = [ bootstrap_cmds bison flex gnum4 unifdef perl python3 ];

  patches = lib.optionals stdenv.isx86_64 [
    ./python3.patch
    ./0001-Implement-missing-availability-platform.patch
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "/bin/" "" \
      --replace-fail "MAKEJOBS := " '# MAKEJOBS := '

    substituteInPlace makedefs/MakeInc.cmd \
      --replace-fail "/usr/bin/" "" \
      --replace-fail "/bin/" ""

    substituteInPlace makedefs/MakeInc.def \
      --replace-fail "-c -S -m" "-c -m"

    substituteInPlace makedefs/MakeInc.top \
      --replace-fail "MEMORY_SIZE := " 'MEMORY_SIZE := 1073741824 # '

    substituteInPlace libkern/kxld/Makefile \
      --replace-fail "-Werror " ""

    substituteInPlace SETUP/kextsymboltool/Makefile \
      --replace-fail "-lstdc++" "-lc++ -lc++abi"

    substituteInPlace libsyscall/xcodescripts/mach_install_mig.sh \
      --replace-fail "/usr/include" "/include" \
      --replace-fail 'MIG=`' "# " \
      --replace-fail 'MIGCC=`' "# " \
      --replace-fail '$SRC/$mig' '-I$DSTROOT/include $SRC/$mig' \
      --replace-fail '$SRC/servers/netname.defs' \
                     '-I$DSTROOT/include $SRC/servers/netname.defs' \
      --replace-fail '$BUILT_PRODUCTS_DIR/mig_hdr' '$BUILT_PRODUCTS_DIR' \

    patchShebangs .
  '' + lib.optionalString stdenv.isAarch64 ''
    # iig is closed-sourced, we don't have it
    # create an empty file to the header instead
    # this line becomes: echo "" > $@; echo --header ...
    substituteInPlace iokit/DriverKit/Makefile \
      --replace-fail '--def $<' '> $@; echo'
  '';

  PLATFORM = "MacOSX";
  SDKVERSION = "10.13.6";
  CC = "${stdenv.cc.targetPrefix or ""}cc";
  CXX = "${stdenv.cc.targetPrefix or ""}c++";
  MIG = "mig";
  MIGCOM = "migcom";
  STRIP = "${stdenv.cc.bintools.targetPrefix or ""}strip";
  RANLIB = "${stdenv.cc.bintools.targetPrefix or ""}ranlib";
  NM = "${stdenv.cc.bintools.targetPrefix or ""}nm";
  UNIFDEF = "unifdef";
  DSYMUTIL = "dsymutil";
  HOST_OS_VERSION = "10.13.6";
  HOST_CC = "${buildPackages.stdenv.cc.targetPrefix or ""}cc";
  HOST_FLEX = "flex";
  HOST_BISON = "bison";
  HOST_GM4 = "m4";
  MIGCC = "cc";
  ARCHS = arch;
  ARCH_CONFIGS = arch;

  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  preBuild = let
    macosVersions = "10.0 10.1 10.2 10.3 10.4 10.5 10.6 10.7 10.8 10.9 10.10 10.10.2 10.10.3 10.11 10.11.2 10.11.3 10.11.4 10.12 10.12.1 10.12.2 10.12.4 10.13 10.13.1 10.13.2 10.13.4";
    iosVersions = "2.0 2.1 2.2 3.0 3.1 3.2 4.0 4.1 4.2 4.3 5.0 5.1 6.0 6.1 7.0 7.1 8.0 8.1 8.2 8.3 8.4 9.0 9.1 9.2 9.3 10.0 10.1 10.2 10.3 11.0 11.1 11.2 11.3 11.4";
   in ''
    # This is a bit of a hack...
    mkdir -p sdk/usr/local/libexec

    cat > sdk/usr/local/libexec/availability.pl <<EOF
      #!$SHELL
      if [ "\$1" == "--macosx" ]; then
        echo ${macosVersions}
      elif [ "\$1" == "--ios" ]; then
        echo ${iosVersions}
      fi
    EOF
    chmod +x sdk/usr/local/libexec/availability.pl

    export SDKROOT_RESOLVED=$PWD/sdk
    export HOST_SDKROOT_RESOLVED=$PWD/sdk

    export BUILT_PRODUCTS_DIR=.
    export DSTROOT=$out
  '';

  buildFlags = lib.optional headersOnly "exporthdrs";
  installTargets = lib.optional headersOnly "installhdrs";

  postInstall = lib.optionalString headersOnly ''
    mv $out/usr/include $out

    (cd BUILD/obj/EXPORT_HDRS && find -type f -exec install -D \{} $out/include/\{} \;)

    # TODO: figure out why I need to do this
    cp libsyscall/wrappers/*.h $out/include
    install -D libsyscall/os/tsd.h $out/include/os/tsd.h
    cp EXTERNAL_HEADERS/AssertMacros.h $out/include
    cp EXTERNAL_HEADERS/Availability*.h $out/System/Library/Frameworks/Kernel.framework/Versions/A/Headers/
    cp -r EXTERNAL_HEADERS/corecrypto $out/include

    # Build the mach headers we crave
    export SRCROOT=$PWD/libsyscall
    export DERIVED_SOURCES_DIR=$out/include
    export SDKROOT=$out
    export OBJROOT=$PWD
    export BUILT_PRODUCTS_DIR=$out
    libsyscall/xcodescripts/mach_install_mig.sh

    # Get rid of the System prefix
    mv $out/System/* $out/
    rmdir $out/System

    # TODO: do I need this?
    mv $out/internal_hdr/include/mach/*.h $out/include/mach

    # Get rid of some junk lying around
    rm -r $out/internal_hdr $out/usr $out/local

    # Add some symlinks
    ln -s $out/Library/Frameworks/System.framework/Versions/B \
          $out/Library/Frameworks/System.framework/Versions/Current
    ln -s $out/Library/Frameworks/System.framework/Versions/Current/PrivateHeaders \
          $out/Library/Frameworks/System.framework/Headers

    # IOKit (and possibly the others) is incomplete,
    # so let's not make it visible from here...
    mkdir $out/Library/PrivateFrameworks
    mv $out/Library/Frameworks/IOKit.framework $out/Library/PrivateFrameworks
  '';

  appleHeaders = builtins.readFile ./headers-10.13.6.txt;

  meta = {
    maintainers = with lib.maintainers; [ toonn ];
  };
} // lib.optionalAttrs headersOnly {
  HOST_CODESIGN = "echo";
  HOST_CODESIGN_ALLOCATE = "echo";
  LIPO = "echo";
  LIBTOOL = "echo";
  CTFCONVERT = "echo";
  CTFMERGE = "echo";
  CTFINSERT = "echo";
  NMEDIT = "echo";
  IIG = "echo";
})
