{ stdenv, appleDerivation, fetchzip, bootstrap_cmds, bison, flex, gnum4, unifdef, perl }:

appleDerivation {
  phases = [ "unpackPhase" "patchPhase" "installPhase" ];

  buildInputs = [ bootstrap_cmds bison flex gnum4 unifdef perl ];

  patchPhase = ''
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
      --replace '$BUILT_PRODUCTS_DIR/mig_hdr' '$BUILT_PRODUCTS_DIR'

    patchShebangs .
  '';

  installPhase = ''
    # This is a bit of a hack...
    mkdir -p sdk/usr/local/libexec

    cat > sdk/usr/local/libexec/availability.pl <<EOF
      #!$SHELL
      if [ "\$1" == "--macosx" ]; then
        echo 10.0 10.1 10.2 10.3 10.4 10.5 10.6 10.7 10.8 10.9 10.10 10.11
      elif [ "\$1" == "--ios" ]; then
        echo 2.0 2.1 2.2 3.0 3.1 3.2 4.0 4.1 4.2 4.3 5.0 5.1 6.0 6.1 7.0 8.0 9.0
      fi
    EOF
    chmod +x sdk/usr/local/libexec/availability.pl

    export SDKROOT_RESOLVED=$PWD/sdk
    export HOST_SDKROOT_RESOLVED=$PWD/sdk
    export PLATFORM=MacOSX
    export SDKVERSION=10.11

    export CC=cc
    export CXX=c++
    export MIG=${bootstrap_cmds}/bin/mig
    export MIGCOM=${bootstrap_cmds}/libexec/migcom
    export STRIP=sentinel-missing
    export LIPO=sentinel-missing
    export LIBTOOL=sentinel-missing
    export NM=sentinel-missing
    export UNIFDEF=${unifdef}/bin/unifdef
    export DSYMUTIL=sentinel-missing
    export CTFCONVERT=sentinel-missing
    export CTFMERGE=sentinel-missing
    export CTFINSERT=sentinel-missing
    export NMEDIT=sentinel-missing

    export HOST_OS_VERSION=10.7
    export HOST_CC=cc
    export HOST_FLEX=${flex}/bin/flex
    export HOST_BISON=${bison}/bin/bison
    export HOST_GM4=${gnum4}/bin/m4
    export HOST_CODESIGN='echo dummy_codesign'
    export HOST_CODESIGN_ALLOCATE=echo

    export BUILT_PRODUCTS_DIR=.

    export DSTROOT=$out
    make installhdrs

    mv $out/usr/include $out

    # TODO: figure out why I need to do this
    cp libsyscall/wrappers/*.h $out/include
    mkdir -p $out/include/os
    cp libsyscall/os/tsd.h $out/include/os/tsd.h
    cp EXTERNAL_HEADERS/AssertMacros.h $out/include
    cp EXTERNAL_HEADERS/Availability*.h $out/System/Library/Frameworks/Kernel.framework/Versions/A/Headers/

    # Build the mach headers we crave
    export MIGCC=cc
    export ARCHS="x86_64"
    export SRCROOT=$PWD/libsyscall
    export DERIVED_SOURCES_DIR=$out/include
    export SDKROOT=$out
    export OBJROOT=$PWD
    export BUILT_PRODUCTS_DIR=$out
    libsyscall/xcodescripts/mach_install_mig.sh

    # Get rid of the System prefix
    mv $out/System/* $out/

    # TODO: do I need this?
    mv $out/internal_hdr/include/mach/*.h $out/include/mach

    # Get rid of some junk lying around
    rm -rf $out/internal_hdr
    rm -rf $out/usr
    rm -rf $out/local

    # Add some symlinks
    ln -s $out/Library/Frameworks/System.framework/Versions/B \
          $out/Library/Frameworks/System.framework/Versions/Current
    ln -s $out/Library/Frameworks/System.framework/Versions/Current/PrivateHeaders \
          $out/Library/Frameworks/System.framework/Headers

    # IOKit (and possibly the others) is incomplete, so let's not make it visible from here...
    mkdir $out/Library/PrivateFrameworks
    mv $out/Library/Frameworks/IOKit.framework $out/Library/PrivateFrameworks
  '';
}
