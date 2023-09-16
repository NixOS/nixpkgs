{ lib
, pkgsBuildBuild
, buildPackages
, appleDerivation'
, stdenvNoCC
, stdenv
, bison
, flex
, gnum4
, unifdef
, perl
, python3
, bootstrap_cmds
, headersOnly ? true
}:

appleDerivation' (if headersOnly then stdenvNoCC else stdenv) (
  let
    inherit (stdenv) hostPlatform targetPlatform;
    arch = stdenv.hostPlatform.darwinArch;
    targetPrefix = lib.optionalString (targetPlatform != hostPlatform) "${targetPlatform.config}-";

    # Take advantage of the fact that every clang is a cross-compiler. mig doesn’t need to be able to
    # link, so there’s no need to re-wrap the clang.
    migcc = stdenvNoCC.mkDerivation {
      name = "migcc";
      version = lib.getVersion pkgsBuildBuild.clang;
      buildCommand = ''
        mkdir -p $out/bin
        ln -s '${pkgsBuildBuild.clang.cc}/bin/clang' "$out/bin/${stdenvNoCC.targetPlatform.config}-cc"
      '';
    };
  in
  {
  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ bison flex gnum4 unifdef perl python3 bootstrap_cmds migcc ];

  patches = lib.optionals stdenv.isx86_64 [ ./python3.patch ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace "/bin/" "" \
      --replace "MAKEJOBS := " '# MAKEJOBS := '

    substituteInPlace makedefs/MakeInc.cmd \
      --replace "/usr/bin/" "" \
      --replace "/bin/" "" \
      --replace "-Werror " ""

    substituteInPlace makedefs/MakeInc.def \
      --replace "-c -S -m" "-c -m"

    substituteInPlace makedefs/MakeInc.top \
      --replace "MEMORY_SIZE := " 'MEMORY_SIZE := 1073741824 # '

    substituteInPlace libkern/kxld/Makefile \
      --replace "-Werror " ""

    substituteInPlace SETUP/kextsymboltool/Makefile \
      --replace "-lstdc++" "-lc++"

    substituteInPlace libsyscall/xcodescripts/mach_install_mig.sh \
      --replace "/usr/include" "/include" \
      --replace "/usr/local/include" "/include" \
      --replace 'MIG=`' "# " \
      --replace 'MIGCC=`' "# " \
      --replace " -o 0" "" \
      --replace '$SRC/$mig' '-I$DSTROOT/include $SRC/$mig' \
      --replace '$SRC/servers/netname.defs' '-I$DSTROOT/include $SRC/servers/netname.defs' \
      --replace '$BUILT_PRODUCTS_DIR/mig_hdr' '$BUILT_PRODUCTS_DIR' \
      --replace 'MACHINE_ARCH=armv7' 'MACHINE_ARCH=arm64' # this might break the comments saying 32-bit is required

    patchShebangs .
  '' + lib.optionalString stdenv.isAarch64 ''
    # iig is closed-sourced, we don't have it
    # create an empty file to the header instead
    # this line becomes: echo "" > $@; echo --header ...
    substituteInPlace iokit/DriverKit/Makefile \
      --replace '--def $<' '> $@; echo'
  '';

  env = {
    PLATFORM = "MacOSX";
    SDKVERSION = "10.11";
    MIG = "mig";
    MIGCOM = "migcom";
    UNIFDEF = "unifdef";
    DSYMUTIL = "dsymutil";
    HOST_OS_VERSION = "10.10";
    HOST_FLEX = "flex";
    HOST_BISON = "bison";
    HOST_GM4 = "m4";
    MIGCC = "${stdenvNoCC.targetPlatform.config}-cc";
    ARCHS = arch;
    ARCH_CONFIGS = arch;
    CC = "${targetPrefix}cc";
    CXX = "${targetPrefix}c++";
    STRIP = "${targetPrefix}strip";
    RANLIB = "${targetPrefix}ranlib";
    NM = "${targetPrefix}nm";
    HOST_CC = "${targetPrefix}cc";
    HOST_LD = "${targetPrefix}ld";
    NIX_CFLAGS_COMPILE = "-Wno-error";
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
  };

  preBuild = let macosVersion =
    "10.0 10.1 10.2 10.3 10.4 10.5 10.6 10.7 10.8 10.9 10.10 10.11" +
    lib.optionalString stdenv.isAarch64 " 10.12 10.13 10.14 10.15 11.0";
   in ''
    # This is a bit of a hack...
    mkdir -p sdk/usr/local/libexec

    cat > sdk/usr/local/libexec/availability.pl <<EOF
      #!$SHELL
      if [ "\$1" == "--macosx" ]; then
        echo ${macosVersion}
      elif [ "\$1" == "--ios" ]; then
        echo 2.0 2.1 2.2 3.0 3.1 3.2 4.0 4.1 4.2 4.3 5.0 5.1 6.0 6.1 7.0 8.0 9.0
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

    # These headers are needed by Libsystem.
    cp libsyscall/wrappers/{spawn/spawn.h,libproc/libproc.h} $out/include

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
    rm -rf $out/internal_hdr $out/usr $out/local

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

  appleHeaders = builtins.readFile (./. + "/headers-${arch}.txt");
})
