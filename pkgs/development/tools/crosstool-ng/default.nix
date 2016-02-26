{ stdenv, lib, makeWrapper, fetchurl, writeScript
, gcc, m4, perl, which, gperf, bison, flex, texinfo, wget, libtool, automake
, ncurses, file, unzip, python, expat
}:
let
  inherit (lib) concatMapStringsSep;
  inherit (stdenv) mkDerivation ;
  inherit (stdenv.lib) overrideDerivation;

  version = "1.20.0";

  gcc-wrapper-with-triple = mkDerivation rec {
    name = "gcc-with-triple-fakey";
    srcs = [];
    builder = writeScript "${name}-builder.sh" ''
      source $stdenv/setup
      mkdir -p $out/bin
      ln -s $NIX_CC/bin/gcc $out/bin/$(basename $(find ${gcc.cc.outPath}/bin -name \*-gcc))
      ln -s $NIX_CC/bin/g++ $out/bin/$(basename $(find ${gcc.cc.outPath}/bin -name \*-g++))
    '';
  };

  # We override expat to provide static libs as well since the ct-ng config
  # might want static libs
  expat-static = overrideDerivation expat (origAttrs: {
    dontDisableStatic = true;
  });

in mkDerivation rec {
  name = "crosstool-ng-${version}";

  src = fetchurl {
    url = "http://crosstool-ng.org/download/crosstool-ng/${name}.tar.bz2";
    sha256 = "0r1lqwqgw90q3a3gpr1a29zvn84r5d9id17byrid5nxmld8x5cdz";
  };

  buildInputs = [ makeWrapper ];

  # This patch adds a call to the script patchToolchainSourcesScript
  # after ct-ng does its own patching.
  patches = [ ./ct-ng.patch ];

  # This script is executed by ct-ng after it does its own patching.
  # It fixes some absolute pathes (/bin/pwd) in toolchain sources
  patchToolchainSourcesScript = ./patch-toolchain-sources.sh;

  # Clearing CC was required otherwise the target compiler was misidentified
  # when building the ncurses (dependency of native gdb)
  # CXX cleared simply because CC was also cleared, although clearing it may
  # not be required
  postInstall = ''
    # We use substituteInPlace in patchToolchainSourcesScript so add it to ct-ng
    declare -f substitute >> $out/lib/ct-ng.${version}/scripts/functions
    declare -f substituteInPlace >> $out/lib/ct-ng.${version}/scripts/functions

    # ct-ng.patch adds a call to the function defined in patchToolchainSourcesScript
    cat $patchToolchainSourcesScript >> $out/lib/ct-ng.${version}/scripts/functions

    # ct-ng requires all its inputs be discoverable for building (just adding to
    # PATH is insufficient) so we make use of stdenv's setup, but only if run
    # standalone. We use whether NIX_BUILD_TOP is set or not to determine this.
    wrapProgram $out/bin/ct-ng \
      --set LD_LIBRARY_PATH "" \
      --run "if [ -z \"\$NIX_BUILD_TOP\" ]; then \
                NIX_BUILD_TOP=\$(pwd); \
                propagatedNativeBuildInputs=\"\$(cat $out/nix-support/propagated-native-build-inputs)\"; \
                source $stdenv/setup; \
             fi" \
      --prefix PATH : ${gcc-wrapper-with-triple}/bin \
      --set CC "" \
      --set CXX ""
  '';

  # These are inputs that are both required to install ct-ng and required to
  # build common components of toolchains (e.g. gcc and m4 are required to build
  # gmp when ct-ng is run standalone but are not required for installing ct-ng).
  # None (few?) of these dependencies are discovered by nix since ct-ng is, for
  # the most part, just a collection of shell scripts. The assumption is that
  # anything invoking, or depending on, ct-ng will require all of these
  # dependencies. All propagated build inputs also wrap the ct-ng script so it
  # can be run standalone, meaning any additional build dependencies for
  # toolchain components should also be added.
  propagatedBuildInputs = [
    # To build/run ct-ng
    which gperf bison flex texinfo wget libtool automake ncurses file unzip
    gcc m4   # For building gmp
    perl     # For installing linux headers
    python expat-static # For gdb
  ];
}
