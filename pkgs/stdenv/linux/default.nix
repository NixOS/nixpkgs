# This file constructs the standard build environment for the
# Linux/i686 platform.  It's completely pure; that is, it relies on no
# external (non-Nix) tools, such as /usr/bin/gcc, and it contains a C
# compiler and linker that do not search in default locations,
# ensuring purity of components produced by it.
{ lib
, localSystem, crossSystem, config, overlays

, bootstrapFiles ? { # switch
    "i686-linux" = import ./bootstrap-files/i686.nix;
    "x86_64-linux" = import ./bootstrap-files/x86_64.nix;
    "armv5tel-linux" = import ./bootstrap-files/armv5tel.nix;
    "armv6l-linux" = import ./bootstrap-files/armv6l.nix;
    "armv7l-linux" = import ./bootstrap-files/armv7l.nix;
    "aarch64-linux" = import ./bootstrap-files/aarch64.nix;
    "mips64el-linux" = import ./bootstrap-files/loongson2f.nix;
  }.${localSystem.system}
    or (abort "unsupported platform for the pure Linux stdenv")
}:

assert crossSystem == null;

let
  inherit (localSystem) system platform;

  commonPreHook =
    ''
      export NIX_ENFORCE_PURITY="''${NIX_ENFORCE_PURITY-1}"
      export NIX_ENFORCE_NO_NATIVE="''${NIX_ENFORCE_NO_NATIVE-1}"
      ${if system == "x86_64-linux" then "NIX_LIB64_IN_SELF_RPATH=1" else ""}
      ${if system == "mips64el-linux" then "NIX_LIB32_IN_SELF_RPATH=1" else ""}
    '';


  # The bootstrap process proceeds in several steps.


  # Create a standard environment by downloading pre-built binaries of
  # coreutils, GCC, etc.


  # Download and unpack the bootstrap tools (coreutils, GCC, Glibc, ...).
  bootstrapTools = import ./bootstrap-tools { inherit system bootstrapFiles; };


  # This function builds the various standard environments used during
  # the bootstrap.  In all stages, we build an stdenv and the package
  # set that can be built with that stdenv.
  stageFun = prevStage:
    { name, overrides ? (self: super: {}), extraBuildInputs ? [] }:

    let

      thisStdenv = import ../generic {
        name = "stdenv-linux-boot";
        buildPlatform = localSystem;
        hostPlatform = localSystem;
        targetPlatform = localSystem;
        inherit config extraBuildInputs;
        preHook =
          ''
            # Don't patch #!/interpreter because it leads to retained
            # dependencies on the bootstrapTools in the final stdenv.
            dontPatchShebangs=1
            ${commonPreHook}
          '';
        shell = "${bootstrapTools}/bin/bash";
        initialPath = [bootstrapTools];

        fetchurlBoot = import ../../build-support/fetchurl/boot.nix {
          inherit system;
        };

        cc = if isNull prevStage.gcc-unwrapped
             then null
             else lib.makeOverridable (import ../../build-support/cc-wrapper) {
          nativeTools = false;
          nativeLibc = false;
          buildPackages = lib.optionalAttrs (prevStage ? stdenv) {
            inherit (prevStage) stdenv;
          };
          hostPlatform = localSystem;
          targetPlatform = localSystem;
          cc = prevStage.gcc-unwrapped;
          isGNU = true;
          libc = prevStage.glibc;
          inherit (prevStage) binutils coreutils gnugrep;
          name = name;
          stdenv = prevStage.ccWrapperStdenv;
        };

        extraAttrs = {
          # Having the proper 'platform' in all the stdenvs allows getting proper
          # linuxHeaders for example.
          inherit platform;

          # stdenv.glibc is used by GCC build to figure out the system-level
          # /usr/include directory.
          inherit (prevStage) glibc;
        };
        overrides = self: super: (overrides self super) // { fetchurl = thisStdenv.fetchurlBoot; };
      };

    in {
      inherit config overlays;
      stdenv = thisStdenv;
    };

in

[

  ({}: {
    __raw = true;

    gcc-unwrapped = null;
    glibc = null;
    binutils = null;
    coreutils = null;
    gnugrep = null;
  })

  # Build a dummy stdenv with no GCC or working fetchurl.  This is
  # because we need a stdenv to build the GCC wrapper and fetchurl.
  (prevStage: stageFun prevStage {
    name = null;

    overrides = self: super: {
      # We thread stage0's stdenv through under this name so downstream stages
      # can use it for wrapping gcc too. This way, downstream stages don't need
      # to refer to this stage directly, which violates the principle that each
      # stage should only access the stage that came before it.
      ccWrapperStdenv = self.stdenv;
      # The Glibc include directory cannot have the same prefix as the
      # GCC include directory, since GCC gets confused otherwise (it
      # will search the Glibc headers before the GCC headers).  So
      # create a dummy Glibc here, which will be used in the stdenv of
      # stage1.
      glibc = self.stdenv.mkDerivation {
        name = "bootstrap-glibc";
        buildCommand = ''
          mkdir -p $out
          ln -s ${bootstrapTools}/lib $out/lib
          ln -s ${bootstrapTools}/include-glibc $out/include
        '';
      };
      gcc-unwrapped = bootstrapTools;
      binutils = bootstrapTools;
      coreutils = bootstrapTools;
      gnugrep = bootstrapTools;
    };
  })


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
  (prevStage: stageFun prevStage {
    name = "bootstrap-gcc-wrapper";

    # Rebuild binutils to use from stage2 onwards.
    overrides = self: super: {
      binutils = super.binutils.override { gold = false; };
      inherit (prevStage)
        ccWrapperStdenv
        glibc gcc-unwrapped coreutils gnugrep;

      # A threaded perl build needs glibc/libpthread_nonshared.a,
      # which is not included in bootstrapTools, so disable threading.
      # This is not an issue for the final stdenv, because this perl
      # won't be included in the final stdenv and won't be exported to
      # top-level pkgs as an override either.
      perl = super.perl.override { enableThreading = false; };
    };
  })


  # 2nd stdenv that contains our own rebuilt binutils and is used for
  # compiling our own Glibc.
  (prevStage: stageFun prevStage {
    name = "bootstrap-gcc-wrapper";

    overrides = self: super: {
      inherit (prevStage)
        ccWrapperStdenv
        binutils gcc-unwrapped coreutils gnugrep
        perl paxctl gnum4 bison;
      # This also contains the full, dynamically linked, final Glibc.
    };
  })


  # Construct a third stdenv identical to the 2nd, except that this
  # one uses the rebuilt Glibc from stage2.  It still uses the recent
  # binutils and rest of the bootstrap tools, including GCC.
  (prevStage: stageFun prevStage {
    name = "bootstrap-gcc-wrapper";

    overrides = self: super: rec {
      inherit (prevStage)
        ccWrapperStdenv
        binutils glibc coreutils gnugrep
        perl patchelf linuxHeaders gnum4 bison;
      # Link GCC statically against GMP etc.  This makes sense because
      # these builds of the libraries are only used by GCC, so it
      # reduces the size of the stdenv closure.
      gmp = super.gmp.override { stdenv = self.makeStaticLibraries self.stdenv; };
      mpfr = super.mpfr.override { stdenv = self.makeStaticLibraries self.stdenv; };
      libmpc = super.libmpc.override { stdenv = self.makeStaticLibraries self.stdenv; };
      isl_0_14 = super.isl_0_14.override { stdenv = self.makeStaticLibraries self.stdenv; };
      gcc-unwrapped = super.gcc-unwrapped.override {
        isl = isl_0_14;
      };
    };
    extraBuildInputs = [ prevStage.patchelf prevStage.paxctl ] ++
      # Many tarballs come with obsolete config.sub/config.guess that don't recognize aarch64.
      lib.optional (system == "aarch64-linux") prevStage.updateAutotoolsGnuConfigScriptsHook;
  })


  # Construct a fourth stdenv that uses the new GCC.  But coreutils is
  # still from the bootstrap tools.
  (prevStage: stageFun prevStage {
    name = "";

    overrides = self: super: {
      # Zlib has to be inherited and not rebuilt in this stage,
      # because gcc (since JAR support) already depends on zlib, and
      # then if we already have a zlib we want to use that for the
      # other purposes (binutils and top-level pkgs) too.
      inherit (prevStage) gettext gnum4 bison gmp perl glibc zlib linuxHeaders;

      gcc = lib.makeOverridable (import ../../build-support/cc-wrapper) {
        nativeTools = false;
        nativeLibc = false;
        isGNU = true;
        buildPackages = {
          inherit (prevStage) stdenv;
        };
        hostPlatform = localSystem;
        targetPlatform = localSystem;
        cc = prevStage.gcc-unwrapped;
        libc = self.glibc;
        inherit (self) stdenv binutils coreutils gnugrep;
        name = "";
        shell = self.bash + "/bin/bash";
      };
    };
    extraBuildInputs = [ prevStage.patchelf prevStage.xz ] ++
      # Many tarballs come with obsolete config.sub/config.guess that don't recognize aarch64.
      lib.optional (system == "aarch64-linux") prevStage.updateAutotoolsGnuConfigScriptsHook;
  })

  # Construct the final stdenv.  It uses the Glibc and GCC, and adds
  # in a new binutils that doesn't depend on bootstrap-tools, as well
  # as dynamically linked versions of all other tools.
  #
  # When updating stdenvLinux, make sure that the result has no
  # dependency (`nix-store -qR') on bootstrapTools or the first
  # binutils built.
  (prevStage: {
    inherit config overlays;
    stdenv = import ../generic rec {
      buildPlatform = localSystem;
      hostPlatform = localSystem;
      targetPlatform = localSystem;
      inherit config;

      preHook = ''
        # Make "strip" produce deterministic output, by setting
        # timestamps etc. to a fixed value.
        commonStripFlags="--enable-deterministic-archives"
        ${commonPreHook}
      '';

      initialPath =
        ((import ../common-path.nix) {pkgs = prevStage;});

      extraBuildInputs = [ prevStage.patchelf prevStage.paxctl ] ++
        # Many tarballs come with obsolete config.sub/config.guess that don't recognize aarch64.
        lib.optional (system == "aarch64-linux") prevStage.updateAutotoolsGnuConfigScriptsHook;

      cc = prevStage.gcc;

      shell = cc.shell;

      inherit (prevStage.stdenv) fetchurlBoot;

      extraAttrs = {
        inherit (prevStage) glibc;
        inherit platform bootstrapTools;
        shellPackage = prevStage.bash;
      };

      /* outputs TODO
      allowedRequisites = with prevStage;
        [ gzip bzip2 xz bash binutils coreutils diffutils findutils gawk
          glibc gnumake gnused gnutar gnugrep gnupatch patchelf attr acl
          paxctl zlib pcre linuxHeaders ed gcc gcc.cc libsigsegv
        ] ++ lib.optional (system == "aarch64-linux") prevStage.updateAutotoolsGnuConfigScriptsHook;
        */

      overrides = self: super: {
        inherit (prevStage)
          gzip bzip2 xz bash coreutils diffutils findutils gawk
          glibc gnumake gnused gnutar gnugrep gnupatch patchelf
          attr acl paxctl zlib pcre;
      } // lib.optionalAttrs (super.targetPlatform == localSystem) {
        # Need to get rid of these when cross-compiling.
        inherit (prevStage) binutils;
        gcc = cc;
      };
    };
  })

]
