rec {

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
    postProcess = [./scripts/add-symlink.sh /* ./scripts/fix-outpath.sh */];
    addToPath = [coreutils findutils gnused];
    extra = linuxHeaders;
  };

  
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
}
