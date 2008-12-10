# This file constructs the standard build environment for the
# Linux/i686 platform.  It's completely pure; that is, it relies on no
# external (non-Nix) tools, such as /usr/bin/gcc, and it contains a C
# compiler and linker that do not search in default locations,
# ensuring purity of components produced by it.

# The function defaults are for easy testing.
{system ? "i686-linux", allPackages ? import ../../top-level/all-packages.nix}:

rec {

  bootstrapTools =
    if system == "i686-linux" then import ./bootstrap/i686
    else if system == "x86_64-linux" then import ./bootstrap/x86_64
    else if system == "powerpc-linux" then import ./bootstrap/powerpc
    else abort "unsupported platform for the pure Linux stdenv";


  # The bootstrap process proceeds in several steps.

  
  # 1) Create a standard environment by downloading pre-built
  # statically linked binaries of coreutils, gcc, etc.

  # To fetch the pre-built binaries, we use a statically linked `curl'
  # binary which is unpacked here.
  curl = derivation {
    inherit system;
    name = "curl";
    builder = bootstrapTools.bash;
    inherit (bootstrapTools) bzip2 cp curl;
    args = [ ./scripts/unpack-curl.sh ];
  };

  # This function downloads a file.
  download = {url, sha1, pkgname}: derivation {
    name = baseNameOf (toString url);
    builder = bootstrapTools.bash;
    inherit system curl url;
    args = [ ./scripts/download.sh ];
    outputHashAlgo = "sha1";
    outputHash = sha1;
    impureEnvVars = [ "http_proxy" "https_proxy" "ftp_proxy" "all_proxy" "no_proxy" ];
  };

  # This function downloads and unpacks a file.
  downloadAndUnpack = pkgname: {url, sha1}: derivation {
    name = pkgname;
    builder = bootstrapTools.bash;
    inherit (bootstrapTools) bzip2 tar cp;
    args = [ ./scripts/unpack.sh ];
    tarball = download {inherit url sha1 pkgname;};
    inherit system;
    allowedReferences = [];
  };

  # The various statically linked components that make up the standard
  # environment.
  staticTools = downloadAndUnpack "static-tools" bootstrapTools.staticToolsURL;
  staticBinutils = downloadAndUnpack "static-binutils" bootstrapTools.binutilsURL;
  staticGCC = (downloadAndUnpack "static-gcc" bootstrapTools.gccURL)
    // { langC = true; langCC = false; langF77 = false; };
  staticGlibc = downloadAndUnpack "static-glibc" bootstrapTools.glibcURL;


  # A helper function to call gcc-wrapper.
  wrapGCC =
    {gcc ? staticGCC, libc, binutils, shell ? ""}:
    (import ../../build-support/gcc-wrapper) {
      nativeTools = false;
      nativeLibc = false;
      inherit gcc binutils libc shell;
      stdenv = stdenvInitial;
    };


  # The "fake" standard environment used to build "real" standard
  # environments.  It consists of just the basic statically linked
  # tools.
  stdenvInitial = let {
    body = derivation {
      name = "stdenv-linux-initial";
      builder = bootstrapTools.bash;
      args = [ ./scripts/builder-stdenv-initial.sh ];
      stdenvScript = ../generic/setup.sh;
      inherit system staticTools curl;
    } // {
      # !!! too much duplication with stdenv/generic/default.nix
      mkDerivation = attrs: (derivation ((removeAttrs attrs ["meta"]) // {
        builder = bootstrapTools.bash;
        args = ["-e" attrs.builder];
        stdenv = body;
        system = body.system;
      })) // { meta = if attrs ? meta then attrs.meta else {}; };
      shell = bootstrapTools.bash;
    };
  };


  # This function builds the various standard environments used during
  # the bootstrap.
  stdenvBootFun =
    {gcc, staticGlibc, extraAttrs ? {}, extraPath ? []}:

    let
      fetchurlBoot = import ../../build-support/fetchurl {
        stdenv = stdenvInitial;
        inherit curl;
      };
    in import ../generic {
      name = "stdenv-linux-boot";
      param1 = if staticGlibc then "static" else "dynamic";
      preHook = ./scripts/prehook.sh;
      stdenv = stdenvInitial;
      shell = bootstrapTools.bash;
      initialPath = [staticTools] ++ extraPath;
      inherit fetchurlBoot;
      forceFetchurlBoot = true;
      inherit gcc extraAttrs;
    };


  # Create the first "real" standard environment.  This one consists
  # of statically linked components only, and a minimal glibc to keep
  # the gcc configure script happy.
  stdenvLinuxBoot1 = stdenvBootFun {
    # Use the statically linked, downloaded glibc/gcc/binutils.
    gcc = wrapGCC {libc = staticGlibc; binutils = staticBinutils;};
    staticGlibc = true;
  };
  

  # 2) These are the packages that we can build with the first
  #    stdenv.  We only need Glibc (in step 3).
  stdenvLinuxBoot1Pkgs = allPackages {
    inherit system;
    bootStdenv = stdenvLinuxBoot1;
  };

  
  # 3) Build Glibc with the statically linked tools.  The result is the
  #    full, dynamically linked, final Glibc.
  stdenvLinuxGlibc = stdenvLinuxBoot1Pkgs.glibc;

  
  # 4) Construct a second stdenv identical to the first, except that
  #    this one uses the Glibc built in step 3.  It still uses
  #    statically linked tools.
  stdenvLinuxBoot2 = removeAttrs (stdenvBootFun {
    staticGlibc = false;
    gcc = wrapGCC {binutils = staticBinutils; libc = stdenvLinuxGlibc;};
    extraAttrs = {glibc = stdenvLinuxGlibc;};
  }) ["gcc" "binutils"];

  
  # 5) The packages that can be built using the second stdenv.
  stdenvLinuxBoot2Pkgs = allPackages {
    inherit system;
    bootStdenv = stdenvLinuxBoot2;
  };


  # Ugh, some packages in stdenvLinuxBoot3Pkgs need "sh", so create a
  # package that contains just a symlink to bash.
  shSymlink = stdenvLinuxBoot2Pkgs.runCommand "sh-symlink" {} ''
    ensureDir $out/bin
    ln -s $shell $out/bin/sh
  '';

  
  # 6) Construct a third stdenv identical to the second, except that
  #    this one uses the dynamically linked GCC and Binutils from step
  #    5.  The other tools (e.g. coreutils) are still static.
  stdenvLinuxBoot3 = stdenvBootFun {
    staticGlibc = false;
    gcc = wrapGCC {
      inherit (stdenvLinuxBoot2Pkgs) binutils;
      libc = stdenvLinuxGlibc;
      gcc = stdenvLinuxBoot2Pkgs.gcc.gcc;
    };
    extraPath = [stdenvLinuxBoot2Pkgs.replace shSymlink];
  };

  
  # 7) The packages that can be built using the third stdenv.
  stdenvLinuxBoot3Pkgs = allPackages {
    inherit system;
    bootStdenv = stdenvLinuxBoot3;
  };

  
  # 8) Construct the final stdenv.  It uses the Glibc, GCC and
  #    Binutils built above, and adds in dynamically linked versions
  #    of all other tools.
  stdenvLinux = import ../generic {
    name = "stdenv-linux";
    preHook = ./scripts/prehook.sh;
    initialPath = [
      ((import ../common-path.nix) {pkgs = stdenvLinuxBoot3Pkgs;})
      stdenvLinuxBoot3Pkgs.patchelf
    ];

    stdenv = stdenvInitial;

    gcc = wrapGCC {
      inherit (stdenvLinuxBoot2Pkgs) binutils;
      libc = stdenvLinuxGlibc;
      gcc = stdenvLinuxBoot2Pkgs.gcc.gcc;
      shell = stdenvLinuxBoot3Pkgs.bash + "/bin/sh";
    };

    shell = stdenvLinuxBoot3Pkgs.bash + "/bin/sh";
    
    fetchurlBoot = stdenvLinuxBoot3.fetchurlBoot;
    forceFetchurlBoot = false;
    
    extraAttrs = {
      inherit (stdenvLinuxBoot2Pkgs) binutils /* gcc */ glibc;
      inherit (stdenvLinuxBoot3Pkgs)
        gzip bzip2 bash coreutils diffutils findutils gawk
        gnumakeNix gnused gnutar gnugrep patch patchelf
        attr acl;
    };
  };

}
