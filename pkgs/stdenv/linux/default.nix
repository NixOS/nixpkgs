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
    builder = ./bash-static/bash;
    tar = ./gnutar-static/bin/tar;
    gunzip = ./gzip-static/bin/gunzip;
    curl = ./curl-static/curl-7.12.2-static.tar.gz;
    cp = ./tools/cp;
    system = "i686-linux";
    args = [ ./scripts/curl-unpack ];
  };

  # This function downloads and unpacks a file.
  download =
  { url, pkgname, postProcess ? [], addToPath ? []
  , extra ? null, extra2 ? null
  , extra3 ? null, extra4? null, patchelf ? null}:
  derivation {
    name = pkgname;
    builder = ./bash-static/bash;
    tar = ./gnutar-static/bin/tar;
    gunzip = ./gzip-static/bin/gunzip;
    inherit curl url;
    cp = ./tools/cp;
    system = "i686-linux";
    args = [ ./scripts/download-script ];
    inherit postProcess addToPath extra extra2 extra3 extra4 patchelf;
  };

  # The various statically linked components that make up the standard
  # environment.
  coreutils = download {
    url = http://losser.st-lab.cs.uu.nl/~armijn/.nix/coreutils-5.0-static.tar.gz;
    pkgname = "coreutils";
  };

  patchelf = ./patchelf-static/bin/patchelf;

  bzip2 = download {
    url = http://losser.st-lab.cs.uu.nl/~armijn/.nix/bzip2-1.0.2-static.tar.gz;
    pkgname = "bzip2";
  };

  gnumake = download {
    url = http://losser.st-lab.cs.uu.nl/~armijn/.nix/make-3.80-static.tar.gz;
    pkgname = "gnumake";
  };

  binutils = download {
    url = http://losser.st-lab.cs.uu.nl/~armijn/.nix/binutils-2.15-static.tar.gz;
    pkgname = "binutils";
  };

  diffutils = download {
    url = http://losser.st-lab.cs.uu.nl/~armijn/.nix/diffutils-2.8.1-static.tar.gz;
    pkgname = "diffutils";
  };

  gnused = download {
    url = http://losser.st-lab.cs.uu.nl/~armijn/.nix/sed-4.0.7-static.tar.gz;
    pkgname = "gnused";
  };

  gnugrep = download {
    url = http://losser.st-lab.cs.uu.nl/~armijn/.nix/grep-2.5.1-static.tar.gz;
    pkgname = "gnugrep";
  };

  gcc = (download {url = http://losser.st-lab.cs.uu.nl/~armijn/.nix/gcc-3.4.2-static.tar.gz;
    pkgname = "gcc";
    postProcess = [./scripts/fix-outpath.sh];
    addToPath = [coreutils findutils gnused];
  }) // { langC = true; langCC = false; langF77 = false; };

  gawk = download {
    url = http://losser.st-lab.cs.uu.nl/~armijn/.nix/gawk-3.1.3-static.tar.gz;
    pkgname = "gawk";
  };

  patch = download {
    url = http://losser.st-lab.cs.uu.nl/~armijn/.nix/patch-2.5.4-static.tar.gz;
    pkgname = "patch";
  };

  findutils = download {
    url = http://losser.st-lab.cs.uu.nl/~armijn/.nix/findutils-4.1.20-static.tar.gz;
    pkgname = "findutils";
  };

  linuxHeaders = download {
    url = http://losser.st-lab.cs.uu.nl/~armijn/.nix/linux-headers-2.4.25-i386.tar.gz;
    pkgname = "linux-headers";
  };

  glibc = download {
    url = http://losser.st-lab.cs.uu.nl/~armijn/.nix/glibc-2.3.3-static-2.tar.gz;
    pkgname = "glibc";
    patchelf = ./patchelf-static/bin/patchelf;
    postProcess = [./scripts/add-symlink.sh ./scripts/fix-outpath.sh];
    addToPath = [coreutils findutils gnused];
    extra = linuxHeaders;
  };


  # The "fake" standard environment used to build "real" standard
  # environments.  It consists of just bash, coreutils, and sed, which
  # is all that is needed by ../generic/builder.sh.
  stdenvInitial = let {
    body = derivation {
      name = "stdenv-linux-static-initial";
      system = "i686-linux";
      builder = ./bash-static/bash;
      args = ./scripts/builder-stdenv-initial.sh;
      inherit coreutils gnused;
    }  // {
      mkDerivation = attrs: derivation (attrs // {
        builder = ./bash-static/bash;
        args = ["-e" attrs.builder];
        stdenv = body;
        system = body.system;
      });
      shell = ./bash-static/bash;
    };
  };


  # This function builds the various standard environments used during
  # the bootstrap.
  stdenvBootFun = {glibc, gcc, binutils, staticGlibc}: (import ../generic) {
    name = "stdenv-linux-static-boot";
    param1 = if staticGlibc then "static" else "dynamic";
    preHook = ./prehook.sh;
    stdenv = stdenvInitial;
    shell = ./bash-static/bash;
    gcc = (import ../../build-support/gcc-wrapper) {
      stdenv = stdenvInitial;
      nativeTools = false;
      nativeGlibc = false;
      inherit gcc glibc binutils;
    };
    initialPath = [
      coreutils
      ./gnutar-static
      ./gzip-static
      bzip2
      gnused
      gnugrep
      gawk
      gnumake
      findutils
      diffutils
      patch
      ./patchelf-static
    ];
  };


  # Create the first "real" standard environment.  This one consists
  # of statically linked components only, and a minimal glibc to keep
  # the gcc configure script happy.
  stdenvLinuxBoot1 = stdenvBootFun {
    # Use the statically linked, downloaded glibc/gcc/binutils.
    inherit glibc gcc binutils;
    staticGlibc = true;
  };

  # 2) These are the packages that we can build with the first
  #    stdenv.  We only need Glibc (in step 3).
  stdenvLinuxBoot1Pkgs = allPackages {
    stdenv = stdenvLinuxBoot1;
    bootCurl = curl;
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
  };

  # 5) The packages that can be built using the second stdenv.
  stdenvLinuxBoot2Pkgs = allPackages {
    stdenv = stdenvLinuxBoot2;
    bootCurl = curl;
  };

  # 6) Construct a third stdenv identical to the second, except that
  #    this one uses the dynamically linked GCC and Binutils from step
  #    5.  The other tools (e.g. coreutils) are still static.
  stdenvLinuxBoot3 = stdenvBootFun {
    glibc = stdenvLinuxGlibc;
    staticGlibc = false;
    inherit (stdenvLinuxBoot2Pkgs) gcc binutils;
  };

  # 7) The packages that can be built using the third stdenv.
  stdenvLinuxBoot3Pkgs = allPackages {
    stdenv = stdenvLinuxBoot3;
    bootCurl = curl;
  };

  # 8) Construct the final stdenv.  It uses the Glibc, GCC and
  #    Binutils built above, and adds in dynamically linked versions
  #    of all other tools.
  stdenvLinux = (import ../generic) {
    name = "stdenv-nix-linux";
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
  };

  # 8) Finally, the set of components built using the Linux stdenv.
  #    Reuse the tools built in the previous steps.
  stdenvLinuxPkgs =
    allPackages {
      stdenv = stdenvLinux;
      bootCurl = stdenvLinuxBoot3Pkgs.curl;
    } //
    {inherit (stdenvLinuxBoot2Pkgs) binutils gcc;} //
    {inherit (stdenvLinuxBoot3Pkgs)
      gzip bzip2 bash coreutils diffutils findutils gawk
      gnumake gnused gnutar gnugrep curl patch patchelf;
    } //
    {glibc = stdenvLinuxGlibc;};
    
}
