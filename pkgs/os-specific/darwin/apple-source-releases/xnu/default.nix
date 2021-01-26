{ lib, stdenv, appleDerivation, bootstrap_cmds, bison, flex, gnum4, unifdef, writeShellScript
, headersOnly ? true }:

let
  # This could be found as /System/DriverKit/usr/local/libexec/availability.pl
  # TODO: update below output when new macOS SDK released.
  availability_pl = writeShellScript "availability.pl" ''
    if [ "\$1" == "--macosx" ]; then
      echo 10.0 10.1 10.2 10.3 10.4 10.5 10.6 10.7 10.8 10.9 10.10 10.10.2 10.10.3 10.11 10.11.2 10.11.3 10.11.4 10.12 10.12.1 10.12.2 10.12.4 10.13 10.13.1 10.13.2 10.13.4 10.14 10.14.1 10.14.4 10.14.5 10.14.6 10.15 10.15.1
    elif [ "\$1" == "--ios" ]; then
      echo 2.0 2.1 2.2 3.0 3.1 3.2 4.0 4.1 4.2 4.3 5.0 5.1 6.0 6.1 7.0 7.1 8.0 8.1 8.2 8.3 8.4 9.0 9.1 9.2 9.3 10.0 10.1 10.2 10.3 11.0 11.1 11.2 11.3 11.4 12.0 12.1 12.2 12.3 12.4 13.0 13.1 13.2 13.3 13.4 13.5 13.6
    fi
  '';
in
appleDerivation ({
  nativeBuildInputs = [ bootstrap_cmds bison flex gnum4 unifdef ];

  postPatch = ''
    # adding EXTERNAL_HEADERS to export
    substituteInPlace Makefile \
      --replace "EXPINC_SUBDIRS = " "EXPINC_SUBDIRS = EXTERNAL_HEADERS "

    # FIXME: DriverKit build requires iig, which we don't have. Skip DriverKit build.
    substituteInPlace iokit/Makefile \
      --replace "DriverKit" ""

    substituteInPlace makedefs/MakeInc.cmd \
      --replace "/usr/bin/" "" \
      --replace "/bin/" "" \
      --replace '$(XCRUN) -sdk $(HOST_SDKROOT) -find' 'echo -n' \
      --replace '$(XCRUN) -sdk $(SDKROOT) -find' 'echo -n'

    # fix unsupported -S for install
    substituteInPlace makedefs/MakeInc.def \
      --replace "-c -S -m" "-c -m"

    # adding AssertMacros.h to export
    substituteInPlace EXTERNAL_HEADERS/Makefile \
      --replace "EXPORT_FILES = " "EXPORT_FILES = AssertMacros.h "

    substituteInPlace SETUP/kextsymboltool/Makefile \
      --replace "-lstdc++" "-lc++"

    substituteInPlace libsyscall/xcodescripts/mach_install_mig.sh \
      --replace 'xcrun -sdk "$SDKROOT" -find' "echo -n"

    substituteInPlace bsd/sys/make_symbol_aliasing.sh \
      --replace "AVAILABILITY_PL=" "AVAILABILITY_PL=${availability_pl} # "

    patchShebangs --build .
  '';

  makeFlags = [
    # variables in Makefile
    "DSTROOT=$(out)"
    "MAKEJOBS="
    "SYSCTL_HW_PHYSICALCPU="
    "SYSCTL_HW_LOGICALCPU="

    # variables in makedefs/MakeInc.cmd
    "SDKROOT_RESOLVED=/dev/null"
    "HOST_SDKROOT_RESOLVED=/dev/null"
    "PLATFORM=MacOSX"
    "SDKVERSION=${stdenv.macosVersionMin}"
    "HOST_OS_VERSION=${stdenv.macosVersionMin}"
    "IIG=true"  # we don't have iig, and even don't know where to find it.
    "HOST_GM4=m4"

    # variables in makedefs/MakeInc.top
    "MEMORY_SIZE=1073741824"

    # leave for debug
    "USE_WERROR=0"
    # "VERBOSE=YES"
    # "RC_XBS=YES"
  ] ++ lib.optionals headersOnly [
    # we don't need those commands, just make them do nothing
    "CTFCONVERT=true"
    "CTFINSERT=true"
    "CTFMERGE=true"
    "HOST_CODESIGN_ALLOCATE=true"
    "HOST_CODESIGN=true"
    "LIBTOOL=true"
    "LIPO=true"
    "NMEDIT=true"
  ];

  buildFlags = lib.optional headersOnly "exporthdrs";

  installTargets = lib.optional headersOnly "installhdrs";

  postInstall = lib.optionalString headersOnly ''
    # Build the mach headers. This needs to go after making exporthdrs and before killing /usr.
    export OBJROOT=$PWD/BUILD/obj
    export SRCROOT=$PWD/libsyscall
    export SDKROOT=$out
    export BUILT_PRODUCTS_DIR=$out
    export ARCHS=x86_64

    sh -e libsyscall/xcodescripts/mach_install_mig.sh

    # remain this structure on purpose, so we know where a header comes from. Better debug on Libsystem.
    mv $out/usr/include           $out/include
    mv $out/usr/local/include     $out/include/PRIVATE_HEADERS
    mv $out/mig_hdr/include       $out/include/LIBSYSCALL
    mv $out/mig_hdr/local/include $out/include/LIBSYSCALL_PRIVATE

    # TODO: We should not need those headers. Be sure.
    # mv $out/internal_hdr/include $out/include/LIBSYSCALL_INTERNAL
    rm -r $out/internal_hdr

    # steal some headers may be used by Libsystem.
    (cd libsyscall/wrappers
      find . -name "*.h" -exec install -Dm444 {} -t $out/include/LIBSYSCALL_WRAPPERS \;
    )

    (cd BUILD/obj/EXPORT_HDRS/EXTERNAL_HEADERS
      find . -name "*.h" -exec install -Dm444 {} -t $out/include/EXTERNAL_HEADERS  \;
    )

    # Get rid of the System prefix. Do we really need to do that?
    mv $out/System/Library $out/

    # they should be empty, check carefully if not.
    rmdir $out/usr/local $out/usr $out/mig_hdr/local $out/mig_hdr $out/System

    # FIXME: Do we need to add symlink here, instead of Libsystem?
    (cd $out/Library/Frameworks/System.framework/Versions
      ln -s B Current
    )
  '';

  appleHeaders = builtins.readFile ./headers.txt;

  meta = {
    broken = !headersOnly;
  };
})
