# This file constructs the standard build environment for the
# Linux/i686 platform.  It's completely pure; that is, it relies on no
# external (non-Nix) tools, such as /usr/bin/gcc, and it contains a C
# compiler and linker that do not search in default locations,
# ensuring purity of components produced by it.

# The function defaults are for easy testing.
{ system ? builtins.currentSystem
, allPackages ? import ../../top-level/all-packages.nix
, platform ? null, config ? {} }:

rec {

  lib = import ../../../lib;

  bootstrapFiles =
    if system == "i686-linux" then import ./bootstrap/i686.nix
    else if system == "x86_64-linux" then import ./bootstrap/x86_64.nix
    else if system == "armv5tel-linux" then import ./bootstrap/armv5tel.nix
    else if system == "armv6l-linux" then import ./bootstrap/armv6l.nix
    else if system == "armv7l-linux" then import ./bootstrap/armv6l.nix
    else if system == "mips64el-linux" then import ./bootstrap/loongson2f.nix
    else abort "unsupported platform for the pure Linux stdenv";


  commonPreHook =
    ''
      export NIX_ENFORCE_PURITY=1
      havePatchELF=1
      ${if system == "x86_64-linux" then "NIX_LIB64_IN_SELF_RPATH=1" else ""}
      ${if system == "mips64el-linux" then "NIX_LIB32_IN_SELF_RPATH=1" else ""}
    '';


  # The bootstrap process proceeds in several steps.


  # Create a standard environment by downloading pre-built binaries of
  # coreutils, GCC, etc.


  # Download and unpack the bootstrap tools (coreutils, GCC, Glibc, ...).
  bootstrapTools = derivation {
    name = "bootstrap-tools";

    builder = bootstrapFiles.sh;

    args =
      if system == "armv5tel-linux" || system == "armv6l-linux"
        || system == "armv7l-linux"
      then [ ./scripts/unpack-bootstrap-tools-arm.sh ]
      else [ ./scripts/unpack-bootstrap-tools.sh ];

    # FIXME: get rid of curl.
    inherit (bootstrapFiles) bzip2 mkdir curl cpio;

    tarball = import <nix/fetchurl.nix> {
      inherit (bootstrapFiles.bootstrapTools) url sha256;
    };

    inherit system;

    # Needed by the GCC wrapper.
    langC = true;
    langCC = true;
  };


  # A helper function to call gcc-wrapper.
  wrapGCC =
    { gcc, libc, binutils, coreutils, name }:

    lib.makeOverridable (import ../../build-support/gcc-wrapper) {
      nativeTools = false;
      nativeLibc = false;
      inherit gcc binutils coreutils libc name;
      stdenv = stage0.stdenv;
    };


  # This function builds the various standard environments used during
  # the bootstrap.  In all stages, we build an stdenv and the package
  # set that can be built with that stdenv.
  stageFun =
    {gcc, extraAttrs ? {}, overrides ? (pkgs: {}), extraPath ? []}:

    let

      thisStdenv = import ../generic {
        inherit system config;
        name = "stdenv-linux-boot";
        preHook =
          ''
            # Don't patch #!/interpreter because it leads to retained
            # dependencies on the bootstrapTools in the final stdenv.
            dontPatchShebangs=1
            ${commonPreHook}
          '';
        shell = "${bootstrapTools}/bin/sh";
        initialPath = [bootstrapTools] ++ extraPath;
        fetchurlBoot = import ../../build-support/fetchurl {
          stdenv = stage0.stdenv;
          curl = bootstrapTools;
        };
        inherit gcc;
        # Having the proper 'platform' in all the stdenvs allows getting proper
        # linuxHeaders for example.
        extraAttrs = extraAttrs // { inherit platform; };
        overrides = pkgs: (overrides pkgs) // { fetchurl = thisStdenv.fetchurlBoot; };
      };

      thisPkgs = allPackages {
        inherit system platform;
        bootStdenv = thisStdenv;
      };

    in { stdenv = thisStdenv; pkgs = thisPkgs; };


  # Build a dummy stdenv with no GCC or working fetchurl.  This is
  # because we need a stdenv to build the GCC wrapper and fetchurl.
  stage0 = stageFun {
    gcc = "/no-such-path";

    overrides = pkgs: {
      # The Glibc include directory cannot have the same prefix as the
      # GCC include directory, since GCC gets confused otherwise (it
      # will search the Glibc headers before the GCC headers).  So
      # create a dummy Glibc here, which will be used in the stdenv of
      # stage1.
      glibc = stage0.stdenv.mkDerivation {
        name = "bootstrap-glibc";
        buildCommand = ''
          mkdir -p $out
          ln -s ${bootstrapTools}/lib $out/lib
          ln -s ${bootstrapTools}/include-glibc $out/include
        '';
      };
    };
  };


  # Create the first "real" standard environment.  This one consists
  # of bootstrap tools only, and a minimal Glibc to keep the GCC
  # configure script happy.
  #
  # For clarity, we only use the previous stage when specifying these
  # stages.  So stageN should only ever have references for stage{N-1}.
  #
  # If we ever need to use a package from more than one stage back, we
  # simply re-export those packages in the middle stage(s) using the
  # overrides attribute and the inherit syntax.
  stage1 = stageFun {
    gcc = wrapGCC {
      gcc = bootstrapTools;
      libc = stage0.pkgs.glibc;
      binutils = bootstrapTools;
      coreutils = bootstrapTools;
      name = "bootstrap-gcc-wrapper";
    };
    # Rebuild binutils to use from stage2 onwards.
    overrides = pkgs: {
      binutils = pkgs.binutils.override { gold = false; };
      inherit (stage0.pkgs) glibc;
    };
  };


  # 2nd stdenv that contains our own rebuilt binutils and is used for
  # compiling our own Glibc.
  stage2 = stageFun {
    gcc = wrapGCC {
      gcc = bootstrapTools;
      libc = stage1.pkgs.glibc;
      binutils = stage1.pkgs.binutils;
      coreutils = bootstrapTools;
      name = "bootstrap-gcc-wrapper";
    };
    overrides = pkgs: {
      inherit (stage1.pkgs) perl binutils paxctl;
      # This also contains the full, dynamically linked, final Glibc.
    };
  };


  # Construct a third stdenv identical to the 2nd, except that this
  # one uses the rebuilt Glibc from stage2.  It still uses the recent
  # binutils and rest of the bootstrap tools, including GCC.
  stage3 = stageFun {
    gcc = wrapGCC {
      gcc = bootstrapTools;
      libc = stage2.pkgs.glibc;
      binutils = stage2.pkgs.binutils;
      coreutils = bootstrapTools;
      name = "bootstrap-gcc-wrapper";
    };
    overrides = pkgs: {
      inherit (stage2.pkgs) binutils glibc perl;
      # Link GCC statically against GMP etc.  This makes sense because
      # these builds of the libraries are only used by GCC, so it
      # reduces the size of the stdenv closure.
      gmp = pkgs.gmp.override { stdenv = pkgs.makeStaticLibraries pkgs.stdenv; };
      mpfr = pkgs.mpfr.override { stdenv = pkgs.makeStaticLibraries pkgs.stdenv; };
      mpc = pkgs.mpc.override { stdenv = pkgs.makeStaticLibraries pkgs.stdenv; };
      isl = pkgs.isl.override { stdenv = pkgs.makeStaticLibraries pkgs.stdenv; };
      cloog = pkgs.cloog.override { stdenv = pkgs.makeStaticLibraries pkgs.stdenv; };
      ppl = pkgs.ppl.override { stdenv = pkgs.makeStaticLibraries pkgs.stdenv; };
    };
    extraAttrs = {
      glibc = stage2.pkgs.glibc;  # Required by gcc47 build
    };
    extraPath = [ stage2.pkgs.paxctl ];
  };


  # Construct a fourth stdenv that uses the new GCC.  But coreutils is
  # still from the bootstrap tools.
  stage4 = stageFun {
    gcc = wrapGCC {
      gcc = stage3.pkgs.gcc.gcc;
      libc = stage3.pkgs.glibc;
      binutils = stage3.pkgs.binutils;
      coreutils = bootstrapTools;
      name = "";
    };
    extraPath = [ stage3.pkgs.xz ];
    overrides = pkgs: {
      inherit (stage3.pkgs) gettext gnum4 gmp perl glibc;
    };
  };


  # Construct the final stdenv.  It uses the Glibc and GCC, and adds
  # in a new binutils that doesn't depend on bootstrap-tools, as well
  # as dynamically linked versions of all other tools.
  #
  # When updating stdenvLinux, make sure that the result has no
  # dependency (`nix-store -qR') on bootstrapTools or the first
  # binutils built.
  stdenvLinux = import ../generic rec {
    inherit system config;

    preHook =
      ''
        # Make "strip" produce deterministic output, by setting
        # timestamps etc. to a fixed value.
        commonStripFlags="--enable-deterministic-archives"
        ${commonPreHook}
      '';

    initialPath =
      ((import ../common-path.nix) {pkgs = stage4.pkgs;})
      ++ [stage4.pkgs.patchelf stage4.pkgs.paxctl ];

    shell = stage4.pkgs.bash + "/bin/bash";

    gcc = (wrapGCC rec {
      gcc = stage4.stdenv.gcc.gcc;
      libc = stage4.pkgs.glibc;
      inherit (stage4.pkgs) binutils coreutils;
      name = "";
    }).override { inherit shell; };

    fetchurlBoot = stage4.stdenv.fetchurl;

    extraAttrs = {
      inherit (stage4.pkgs) glibc;
      inherit platform bootstrapTools;
      shellPackage = stage4.pkgs.bash;
    };

    overrides = pkgs: {
      inherit gcc;
      inherit (stage4.pkgs)
        gzip bzip2 xz bash binutils coreutils diffutils findutils gawk
        glibc gnumake gnused gnutar gnugrep gnupatch patchelf
        attr acl paxctl;
    };
  };

}
