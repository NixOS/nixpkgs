# This file constructs the standard build environment for the
# Linux/i686 platform.  It's completely pure; that is, it relies on no
# external (non-Nix) tools, such as /usr/bin/gcc, and it contains a C
# compiler and linker that do not search in default locations,
# ensuring purity of components produced by it.

# The function defaults are for easy testing.
{system ? "i686-linux", allPackages ? import ../../top-level/all-packages.nix}:

rec {

  bootstrapFiles =
    if system == "i686-linux" then import ./bootstrap/i686
    else if system == "x86_64-linux" then import ./bootstrap/x86_64
    else if system == "powerpc-linux" then import ./bootstrap/powerpc
    else if system == "armv5tel-linux" then import ./bootstrap/armv5tel
    else abort "unsupported platform for the pure Linux stdenv";


  commonPreHook =
    ''
      export NIX_ENFORCE_PURITY=1
      havePatchELF=1
      ${if system == "x86_64-linux" then "NIX_LIB64_IN_SELF_RPATH=1" else ""}
    '';


  # The bootstrap process proceeds in several steps.

  
  # 1) Create a standard environment by downloading pre-built binaries
  # of coreutils, GCC, etc.

  
  # This function downloads a file.
  download = {url, sha256}: derivation {
    name = baseNameOf (toString url);
    builder = bootstrapFiles.sh;
    inherit system url;
    inherit (bootstrapFiles) bzip2 mkdir curl cpio ln;
    args = [ ./scripts/download.sh ];
    outputHashAlgo = "sha256";
    outputHash = sha256;
    impureEnvVars = [ "http_proxy" "https_proxy" "ftp_proxy" "all_proxy" "no_proxy" ];
  };

  
  # Download and unpack the bootstrap tools (coreutils, GCC, Glibc, ...).
  bootstrapTools = derivation {
    name = "bootstrap-tools";
    
    builder = bootstrapFiles.sh;
    
    args = if (system == "armv5tel-linux") then
      ([ ./scripts/unpack-bootstrap-tools-arm.sh ])
      else 
      ([ ./scripts/unpack-bootstrap-tools.sh ]);
    
    inherit (bootstrapFiles) bzip2 mkdir curl cpio;
    
    tarball = download {
      inherit (bootstrapFiles.bootstrapTools) url sha256;
    };
    
    inherit system;
    
    # Needed by the GCC wrapper.
    langC = true;
    langCC = true;
  };
  

  # This function builds the various standard environments used during
  # the bootstrap.
  stdenvBootFun =
    {gcc, extraAttrs ? {}, extraPath ? [], fetchurl}:

    import ../generic {
      inherit system;
      name = "stdenv-linux-boot";
      param1 = bootstrapTools;
      preHook = builtins.toFile "prehook.sh"
        ''
          # Don't patch #!/interpreter because it leads to retained
          # dependencies on the bootstrapTools in the final stdenv.
          dontPatchShebangs=1
          ${commonPreHook}
        '';
      shell = "${bootstrapTools}/bin/sh";
      initialPath = [bootstrapTools] ++ extraPath;
      fetchurlBoot = fetchurl;
      inherit gcc;
      extraAttrs = extraAttrs // {inherit fetchurl;};
    };

  # Build a dummy stdenv with no GCC or working fetchurl.  This is
  # because we need a stdenv to build the GCC wrapper and fetchurl.
  stdenvLinuxBoot0 = stdenvBootFun {
    gcc = "/no-such-path";
    fetchurl = null;
  };

  
  fetchurl = import ../../build-support/fetchurl {
    stdenv = stdenvLinuxBoot0;
    curl = bootstrapTools;
  };


  # The Glibc include directory cannot have the same prefix as the GCC
  # include directory, since GCC gets confused otherwise (it will
  # search the Glibc headers before the GCC headers).  So create a
  # dummy Glibc.
  bootstrapGlibc = stdenvLinuxBoot0.mkDerivation {
    name = "bootstrap-glibc";
    buildCommand = ''
      ensureDir $out
      ln -s ${bootstrapTools}/lib $out/lib
      ln -s ${bootstrapTools}/include-glibc $out/include
    '';
  };


  # A helper function to call gcc-wrapper.
  wrapGCC =
    {gcc ? bootstrapTools, libc, binutils, coreutils, shell ? "", name ? "bootstrap-gcc-wrapper"}:
    
    import ../../build-support/gcc-wrapper {
      nativeTools = false;
      nativeLibc = false;
      inherit gcc binutils coreutils libc shell name;
      stdenv = stdenvLinuxBoot0;
    };

  # Helper function to override the compiler in stdenv for specific packages.
  overrideGCC = stdenv: gcc: stdenv //
    { mkDerivation = args: stdenv.mkDerivation (args // { NIX_GCC = gcc; });
    };


  # Create the first "real" standard environment.  This one consists
  # of bootstrap tools only, and a minimal Glibc to keep the GCC
  # configure script happy.
  stdenvLinuxBoot1 = stdenvBootFun {
    gcc = wrapGCC {
      libc = bootstrapGlibc;
      binutils = bootstrapTools;
      coreutils = bootstrapTools;
    };
    inherit fetchurl;
  };
  

  # 2) These are the packages that we can build with the first
  #    stdenv.  We only need Glibc (in step 3).
  stdenvLinuxBoot1Pkgs = allPackages {
    inherit system;
    bootStdenv = stdenvLinuxBoot1;
  };

  
  # 3) Build Glibc with the bootstrap tools.  The result is the full,
  #    dynamically linked, final Glibc.
  stdenvLinuxGlibc = stdenvLinuxBoot1Pkgs.glibc;

  
  # 4) Construct a second stdenv identical to the first, except that
  #    this one uses the Glibc built in step 3.  It still uses
  #    the rest of the bootstrap tools, including GCC.
  stdenvLinuxBoot2 = removeAttrs (stdenvBootFun {
    gcc = wrapGCC {
      binutils = bootstrapTools;
      coreutils = bootstrapTools;
      libc = stdenvLinuxGlibc;
    };
    extraAttrs = {
      glibc = stdenvLinuxGlibc;
      inherit (stdenvLinuxBoot1Pkgs) perl;
    };
    inherit fetchurl;
  }) ["gcc" "binutils"];

  
  # 5) The packages that can be built using the second stdenv.
  stdenvLinuxBoot2Pkgs = allPackages {
    inherit system;
    bootStdenv = stdenvLinuxBoot2;
    config = {
      packageOverrides = pkgs : {
        # The stdenv's gcc will not be built with 'ppl'
        # but the resulting 'gcc' attribute of these pkgs will.
        # (that allows bootstrapping from bootstrapTools with old gmp)
        stdenv = overrideGCC pkgs.stdenv (pkgs.wrapGCC (pkgs.gcc.gcc.override {
          ppl = null;
          cloogppl = null;
        }));
      };
    };
  };


  # 6) Construct a third stdenv identical to the second, except that
  #    this one uses the dynamically linked GCC and Binutils from step
  #    5.  The other tools (e.g. coreutils) are still from the
  #    bootstrap tools.
  stdenvLinuxBoot3 = stdenvBootFun {
    gcc = wrapGCC rec {
      inherit (stdenvLinuxBoot2Pkgs) binutils;
      coreutils = bootstrapTools;
      libc = stdenvLinuxGlibc;
      gcc = stdenvLinuxBoot2Pkgs.gcc.gcc;
      name = "";
    };
    extraAttrs = {
      inherit (stdenvLinuxBoot1Pkgs) perl;
    };
    inherit fetchurl;
  };

  
  # 7) The packages that can be built using the third stdenv.
  stdenvLinuxBoot3Pkgs = allPackages {
    inherit system;
    bootStdenv = stdenvLinuxBoot3;
  };

  
  # 8) Construct the final stdenv.  It uses the Glibc, GCC and
  #    Binutils built above, and adds in dynamically linked versions
  #    of all other tools.
  #
  #    When updating stdenvLinux, make sure that the result has no
  #    dependency (`nix-store -qR') on bootstrapTools.
  stdenvLinux = import ../generic {
    name = "stdenv-linux";
    
    inherit system;
    
    preHook = builtins.toFile "prehook.sh" commonPreHook;
    
    initialPath = 
      ((import ../common-path.nix) {pkgs = stdenvLinuxBoot3Pkgs;})
      ++ [stdenvLinuxBoot3Pkgs.patchelf];

    gcc = wrapGCC rec {
      inherit (stdenvLinuxBoot2Pkgs) binutils;
      inherit (stdenvLinuxBoot3Pkgs) coreutils;
      libc = stdenvLinuxGlibc;
      gcc = stdenvLinuxBoot2Pkgs.gcc.gcc;
      shell = stdenvLinuxBoot3Pkgs.bash + "/bin/bash";
      name = "";
    };

    shell = stdenvLinuxBoot3Pkgs.bash + "/bin/bash";
    
    fetchurlBoot = fetchurl;
    
    extraAttrs = {
      inherit (stdenvLinuxBoot2Pkgs) binutils /* gcc */ glibc;
      inherit (stdenvLinuxBoot3Pkgs)
        gzip bzip2 bash coreutils diffutils findutils gawk
        gnumake gnused gnutar gnugrep patch patchelf
        attr acl;
    };
  };

}
