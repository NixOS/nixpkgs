# This file constructs the standard build environment for the
# Linux/i686 platform.  It's completely pure; that is, it relies on no
# external (non-Nix) tools, such as /usr/bin/gcc, and it contains a C
# compiler and linker that do not search in default locations,
# ensuring purity of components produced by it.

{allPackages}:

rec {

  # The bootstrap process proceeds in several steps.

  # 1) Create a standard environment by downloading pre-built
  # statically linked binaries of coreutils, gcc, etc.

  # To fetch the pre-built binaries, we use a statically linked `curl'
  # binary which is unpacked here.
  curl = derivation {
    name = "curl";
    builder = ./tools/bash;
    tar = ./tools/tar;
    bunzip2 = ./tools/bunzip2;
    cp = ./tools/cp;
    curl = ./tools/curl-7.15.1-static.tar.bz2;
    system = "i686-linux";
    args = [ ./scripts/unpack-curl.sh ];
  };

  # This function downloads a file.
  download = {url, md5, pkgname}: derivation {
    name = baseNameOf (toString url);
    system = "i686-linux";
    builder = ./tools/bash;
    inherit curl url;
    args = [ ./scripts/download.sh ];

    # Nix 0.8 fixed-output derivations.
    outputHashAlgo = "md5";
    outputHash = md5;
    
    # Compatibility with Nix <= 0.7.
    id = md5;
  };

  # This function downloads and unpacks a file.
  downloadAndUnpack =
  { url, md5, pkgname, postProcess ? [], addToPath ? []
  , extra ? null, extra2 ? null
  , extra3 ? null, extra4? null, patchelf ? null}:
  derivation {
    name = pkgname;
    system = "i686-linux";
    builder = ./tools/bash;
    tar = ./tools/tar;
    bunzip2 = ./tools/bunzip2;
    cp = ./tools/cp;
    args = [ ./scripts/unpack.sh ];
    tarball = download {inherit url md5 pkgname;};
    inherit postProcess addToPath extra extra2 extra3 extra4 patchelf;
  };

  # The various statically linked components that make up the standard
  # environment.
  staticTools = downloadAndUnpack {
    url = http://nix.cs.uu.nl/dist/tarballs/stdenv-linux/static-tools.tar.bz2;
    pkgname = "static-tools";
    md5 = "90578c603079313123e8c754a85e40d7";
  };

  binutils = downloadAndUnpack {
    url = http://nix.cs.uu.nl/dist/tarballs/stdenv-linux/binutils-2.15-static.tar.bz2;
    pkgname = "binutils";
    md5 = "9c134038b7f1894a4b307d600207047c";
  };

  gcc = (downloadAndUnpack {
    url = http://nix.cs.uu.nl/dist/tarballs/stdenv-linux/gcc-3.4.2-static.tar.bz2;
    pkgname = "gcc";
    md5 = "600452fac470a49a41ea81d39c209f35";
    postProcess = [./scripts/fix-outpath.sh];
    addToPath = [staticTools];
  }) // { langC = true; langCC = false; langF77 = false; };

  glibc = downloadAndUnpack {
    url = http://nix.cs.uu.nl/dist/tarballs/stdenv-linux/glibc-2.3.3-static.tar.bz2;
    pkgname = "glibc";
    md5 = "36ff244e666c60784edfe1cc66f68e4c";
    postProcess = [./scripts/fix-outpath.sh];
    addToPath = [staticTools];
  };


  # The "fake" standard environment used to build "real" standard
  # environments.  It consists of just the basic statically linked
  # tools.
  stdenvInitial = let {
    body = derivation {
      name = "stdenv-linux-initial";
      system = "i686-linux";
      builder = ./tools/bash;
      args = ./scripts/builder-stdenv-initial.sh;
      inherit staticTools;
    }  // {
      mkDerivation = attrs: derivation ((removeAttrs attrs ["meta"]) // {
        builder = ./tools/bash;
        args = ["-e" attrs.builder];
        stdenv = body;
        system = body.system;
      });
      shell = ./tools/bash;
    };
  };


  # This function builds the various standard environments used during
  # the bootstrap.
  stdenvBootFun =
    {glibc, gcc, binutils, staticGlibc, extraAttrs ? {}}:
    
    import ../generic {
      name = "stdenv-linux-boot";
      param1 = if staticGlibc then "static" else "dynamic";
      preHook = ./prehook.sh;
      stdenv = stdenvInitial;
      shell = ./tools/bash;
      gcc = (import ../../build-support/gcc-wrapper) {
        stdenv = stdenvInitial;
        nativeTools = false;
        nativeGlibc = false;
        inherit gcc glibc binutils;
      };
      initialPath = [
        staticTools
      ];
      inherit extraAttrs;
    };


  # Create the first "real" standard environment.  This one consists
  # of statically linked components only, and a minimal glibc to keep
  # the gcc configure script happy.
  stdenvLinuxBoot1 = stdenvBootFun {
    # Use the statically linked, downloaded glibc/gcc/binutils.
    inherit glibc gcc binutils;
    staticGlibc = true;
    extraAttrs = {inherit curl;};
  };

  # 2) These are the packages that we can build with the first
  #    stdenv.  We only need Glibc (in step 3).
  stdenvLinuxBoot1Pkgs = allPackages {
    bootStdenv = stdenvLinuxBoot1;
  };

  # 3) Build Glibc with the statically linked tools.  The result is the
  #    full, dynamically linked, final Glibc.
  stdenvLinuxGlibc = stdenvLinuxBoot1Pkgs.glibc;

  # 4) Construct a second stdenv identical to the first, except that
  #    this one uses the Glibc built in step 3.  It still uses
  #    statically linked tools.
  stdenvLinuxBoot2 = stdenvBootFun {
    glibc = stdenvLinuxGlibc;
    staticGlibc = false;
    inherit gcc binutils;
    extraAttrs = {inherit curl;};
  };

  # 5) The packages that can be built using the second stdenv.
  stdenvLinuxBoot2Pkgs = allPackages {
    bootStdenv = stdenvLinuxBoot2;
  };

  # 6) Construct a third stdenv identical to the second, except that
  #    this one uses the dynamically linked GCC and Binutils from step
  #    5.  The other tools (e.g. coreutils) are still static.
  stdenvLinuxBoot3 = stdenvBootFun {
    glibc = stdenvLinuxGlibc;
    staticGlibc = false;
    inherit (stdenvLinuxBoot2Pkgs) gcc binutils;
    extraAttrs = {inherit curl;};
  };

  # 7) The packages that can be built using the third stdenv.
  stdenvLinuxBoot3Pkgs = allPackages {
    bootStdenv = stdenvLinuxBoot3;
  };

  # 8) Construct the final stdenv.  It uses the Glibc, GCC and
  #    Binutils built above, and adds in dynamically linked versions
  #    of all other tools.
  stdenvLinux = (import ../generic) {
    name = "stdenv-linux";
    preHook = ./prehook.sh;
    initialPath = [
      ((import ../nix/path.nix) {pkgs = stdenvLinuxBoot3Pkgs;})
      stdenvLinuxBoot3Pkgs.patchelf
    ];

    stdenv = stdenvInitial;

    gcc = (import ../../build-support/gcc-wrapper) {
      stdenv = stdenvInitial;
      nativeTools = false;
      nativeGlibc = false;
      inherit (stdenvLinuxBoot2Pkgs) gcc binutils;
      glibc = stdenvLinuxGlibc;
      shell = stdenvLinuxBoot3Pkgs.bash ~ /bin/sh;
    };

    shell = stdenvLinuxBoot3Pkgs.bash ~ /bin/sh;
    
    extraAttrs = {
      curl = stdenvLinuxBoot3Pkgs.realCurl;
      inherit (stdenvLinuxBoot2Pkgs) binutils /* gcc */;
      inherit (stdenvLinuxBoot3Pkgs)
        gzip bzip2 bash coreutils diffutils findutils gawk
        gnumake gnused gnutar gnugrep patch patchelf;
    };
  };

}
