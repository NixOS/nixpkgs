{
  lib,
  AvailabilityVersions,
  apple-sdk,
  bison,
  bootstrap_cmds,
  buildPackages,
  flex,
  gnum4,
  mkAppleDerivation,
  perl,
  python3,
  stdenv,
  unifdef,
}:

mkAppleDerivation {
  pname = "xnuHeaders";
  releaseName = "xnu";

  postPatch = ''
    rm bsd/sys/make_symbol_aliasing.sh
    substitute ${buildPackages.darwin.AvailabilityVersions}/libexec/make_symbol_aliasing.sh bsd/sys/make_symbol_aliasing.sh \
      --replace-fail '--threshold $SDKROOT' ""
    chmod a+x bsd/sys/make_symbol_aliasing.sh

    substituteInPlace Makefile \
      --replace-fail "/bin/" "" \
      --replace-fail "MAKEJOBS := " '# MAKEJOBS := '

    substituteInPlace makedefs/MakeInc.cmd \
      --replace-fail "/usr/bin/" "" \
      --replace-fail "/bin/" ""

    substituteInPlace makedefs/MakeInc.def \
      --replace-fail "-c -S -m" "-c -m" \
      --replace-fail '-mno-implicit-sme' ""

    substituteInPlace makedefs/MakeInc.top \
      --replace-fail "MEMORY_SIZE := " 'MEMORY_SIZE := 1073741824 # '

    # iig is closed-sourced, we don't have it
    # create an empty file to the header instead
    # this line becomes: echo "" > $@; echo --header ...
    substituteInPlace iokit/DriverKit/Makefile \
      --replace-fail '--def $<' '> $@; echo'

    patchShebangs .
  '';

  nativeBuildInputs = [
    AvailabilityVersions
    bootstrap_cmds
    bison
    flex
    gnum4
    unifdef
    perl
    python3
  ];

  env = {
    ARCHS = stdenv.hostPlatform.darwinArch;
    ARCH_CONFIGS = stdenv.hostPlatform.darwinArch;
    PLATFORM = "MacOSX";
    RC_DARWIN_KERNEL_VERSION = "25.3.0";

    DSTROOT = placeholder "out";

    SDKROOT_RESOLVED = apple-sdk.sdkroot;
    SDKVERSION = stdenv.hostPlatform.darwinMinVersion;

    CTFCONVERT = "echo";
    CTFINSERT = "echo";
    CTFMERGE = "echo";
    DSYMUTIL = "dsymutil";
    IIG = "echo";
    LIBTOOL = "echo";
    LIPO = "echo";
    MIG = "mig";
    MIGCOM = "${lib.getBin buildPackages.darwin.bootstrap_cmds}/libexec/migcom";
    NMEDIT = "echo";
    UNIFDEF = "unifdef";

    HOST_SDKROOT_RESOLVED = buildPackages.apple-sdk.sdkroot;
    HOST_OS_VERSION = buildPackages.stdenv.hostPlatform.darwinMinVersion;

    HOST_BISON = "bison";
    HOST_CC = lib.getExe' buildPackages.clangStdenv.cc "${buildPackages.clangStdenv.cc.targetPrefix}clang";
    HOST_CODESIGN = "echo";
    HOST_CODESIGN_ALLOCATE = "echo";
    HOST_FLEX = "flex";
    HOST_GM4 = "m4";
  };

  buildFlags = [ "exporthdrs" ];
  installTargets = [ "installhdrs" ];

  # Remove public headers. `xnuHeaders` is meant to provide private headers needed to build packages.
  # If you need public headers, use the correct SDK for the version you need.
  postInstall = ''
    mv "$out/System/Library" "$out"
    rm -rf "$out/System" "$out/usr"

    for framework in "$out/Library/Frameworks"/*; do
      rm -rf "$framework/Versions/$ver/Headers" "$framework/Headers"

      if [ ! -L "$framework/Versions/Current" ]; then
        ver=$(ls -r "$framework/Versions" | head -n 1)
        ln -s "$framework/Versions/$ver" "$framework/Versions/Current"
      fi

      ln -s "$framework/Versions/Current/PrivateHeaders" "$framework/PrivateHeaders"
    done

    # Set up the default `include` folder to include the private system headers plus availability headers.
    mkdir -p "$out/include/sys"
    gen-headers ${lib.getVersion apple-sdk} "$out"

    for x in "$out/Library/Frameworks/System.framework/PrivateHeaders"/*; do
      name=$(basename "$x")
      if [ "$name" = "os" ] || [ "$name" = "sys" ]; then
        for y in "$x"/*; do
          dest="$out/include/$name/$(basename "$y")"
          if [ ! -e "$dest" ]; then ln -s "$y" "$out/include/$name/$(basename "$y")"; fi
        done
      else
        ln -s "$x" "$out/include/$(basename "$x")"
      fi
    done
  '';
}
