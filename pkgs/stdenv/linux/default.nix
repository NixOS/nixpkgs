# This file constructs the standard build environment for the
# Linux/i686 platform.  It's completely pure; that is, it relies on no
# external (non-Nix) tools, such as /usr/bin/gcc, and it contains a C
# compiler and linker that do not search in default locations,
# ensuring purity of components produced by it.

# The function defaults are for easy testing.
{ system ? builtins.currentSystem
, allPackages ? import ../../top-level/all-packages.nix
, platform ? null, config ? {}, lib ? (import ../../../lib)
, customBootstrapFiles ? null }:

rec {

  bootstrapFiles =
    if customBootstrapFiles != null then customBootstrapFiles
    else if system == "i686-linux" then import ./bootstrap/i686.nix
    else if system == "x86_64-linux" then import ./bootstrap/x86_64.nix
    else if system == "armv5tel-linux" then import ./bootstrap/armv5tel.nix
    else if system == "armv6l-linux" then import ./bootstrap/armv6l.nix
    else if system == "armv7l-linux" then import ./bootstrap/armv7l.nix
    else if system == "mips64el-linux" then import ./bootstrap/loongson2f.nix
    else abort "unsupported platform for the pure Linux stdenv";


  commonPreHook =
    ''
      export NIX_ENFORCE_PURITY=1
      ${if system == "x86_64-linux" then "NIX_LIB64_IN_SELF_RPATH=1" else ""}
      ${if system == "mips64el-linux" then "NIX_LIB32_IN_SELF_RPATH=1" else ""}
    '';


  # The bootstrap process proceeds in several steps.


  # Create a standard environment by downloading pre-built binaries of
  # coreutils, GCC, etc.


  # Download and unpack the bootstrap tools (coreutils, GCC, Glibc, ...).
  bootstrapTools = derivation {
    name = "bootstrap-tools";

    builder = bootstrapFiles.busybox;

    args = if system == "armv5tel-linux" then
        [ "ash" "-e" ./scripts/unpack-bootstrap-tools-arm.sh ]
      else
        [ "ash" "-e" ./scripts/unpack-bootstrap-tools.sh ];

    tarball = bootstrapFiles.bootstrapTools;

    inherit system;

    # Needed by the GCC wrapper.
    langC = true;
    langCC = true;
    isGNU = true;
  };


  # This function builds the various standard environments used during
  # the bootstrap.  In all stages, we build an stdenv and the package
  # set that can be built with that stdenv.
  stageFun =
    {gccPlain, glibc, binutils, coreutils, gnugrep, name, overrides ? (pkgs: {}), extraBuildInputs ? []}:

    let

      thisStdenv = import ../generic {
        inherit system config extraBuildInputs;
        name = "stdenv-linux-boot";
        preHook =
          ''
            # Don't patch #!/interpreter because it leads to retained
            # dependencies on the bootstrapTools in the final stdenv.
            dontPatchShebangs=1
            ${commonPreHook}
          '';
        shell = "${bootstrapTools}/bin/sh";
        initialPath = [bootstrapTools];
        fetchurlBoot = import ../../build-support/fetchurl {
          stdenv = stage0.stdenv;
          curl = bootstrapTools;
        };

        cc = if isNull gccPlain
             then null
             else lib.makeOverridable (import ../../build-support/cc-wrapper) {
          nativeTools = false;
          nativeLibc = false;
          cc = gccPlain;
          isGNU = true;
          libc = glibc;
          inherit binutils coreutils gnugrep;
          name = name;
          stdenv = stage0.stdenv;
        };

        extraAttrs = {
          # Having the proper 'platform' in all the stdenvs allows getting proper
          # linuxHeaders for example.
          inherit platform;

          # stdenv.glibc is used by GCC build to figure out the system-level
          # /usr/include directory.
          inherit glibc;
        };
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
    gccPlain = null;
    glibc = null;
    binutils = null;
    coreutils = null;
    gnugrep = null;
    name = null;

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
    gccPlain = bootstrapTools;
    inherit (stage0.pkgs) glibc;
    binutils = bootstrapTools;
    coreutils = bootstrapTools;
    gnugrep = bootstrapTools;
    name = "bootstrap-gcc-wrapper";

    # Rebuild binutils to use from stage2 onwards.
    overrides = pkgs: {
      binutils = pkgs.binutils.override { gold = false; };
      inherit (stage0.pkgs) glibc;

      # A threaded perl build needs glibc/libpthread_nonshared.a,
      # which is not included in bootstrapTools, so disable threading.
      # This is not an issue for the final stdenv, because this perl
      # won't be included in the final stdenv and won't be exported to
      # top-level pkgs as an override either.
      perl = pkgs.perl.override { enableThreading = false; };
    };
  };


  # 2nd stdenv that contains our own rebuilt binutils and is used for
  # compiling our own Glibc.
  stage2 = stageFun {
    gccPlain = bootstrapTools;
    inherit (stage1.pkgs) glibc;
    binutils = stage1.pkgs.binutils;
    coreutils = bootstrapTools;
    gnugrep = bootstrapTools;
    name = "bootstrap-gcc-wrapper";

    overrides = pkgs: {
      inherit (stage1.pkgs) perl binutils paxctl;
      # This also contains the full, dynamically linked, final Glibc.
    };
  };


  # Construct a third stdenv identical to the 2nd, except that this
  # one uses the rebuilt Glibc from stage2.  It still uses the recent
  # binutils and rest of the bootstrap tools, including GCC.
  stage3 = stageFun {
    gccPlain = bootstrapTools;
    inherit (stage2.pkgs) glibc binutils;
    coreutils = bootstrapTools;
    gnugrep = bootstrapTools;
    name = "bootstrap-gcc-wrapper";

    overrides = pkgs: rec {
      inherit (stage2.pkgs) binutils glibc perl patchelf linuxHeaders;
      # Link GCC statically against GMP etc.  This makes sense because
      # these builds of the libraries are only used by GCC, so it
      # reduces the size of the stdenv closure.
      gmp = pkgs.gmp.override { stdenv = pkgs.makeStaticLibraries pkgs.stdenv; };
      mpfr = pkgs.mpfr.override { stdenv = pkgs.makeStaticLibraries pkgs.stdenv; };
      libmpc = pkgs.libmpc.override { stdenv = pkgs.makeStaticLibraries pkgs.stdenv; };
      isl_0_11 = pkgs.isl_0_11.override { stdenv = pkgs.makeStaticLibraries pkgs.stdenv; };
      cloog_0_18_0 = pkgs.cloog_0_18_0.override {
        stdenv = pkgs.makeStaticLibraries pkgs.stdenv;
        isl = isl_0_11;
      };
      gccPlain = pkgs.gcc.cc.override {
        isl = isl_0_11;
        cloog = cloog_0_18_0;
      };
    };
    extraBuildInputs = [ stage2.pkgs.patchelf stage2.pkgs.paxctl ];
  };


  # Construct a fourth stdenv that uses the new GCC.  But coreutils is
  # still from the bootstrap tools.
  stage4 = stageFun {
    inherit (stage3.pkgs) gccPlain glibc binutils;
    gnugrep = bootstrapTools;
    coreutils = bootstrapTools;
    name = "";

    overrides = pkgs: {
      # Zlib has to be inherited and not rebuilt in this stage,
      # because gcc (since JAR support) already depends on zlib, and
      # then if we already have a zlib we want to use that for the
      # other purposes (binutils and top-level pkgs) too.
      inherit (stage3.pkgs) gettext gnum4 gmp perl glibc zlib linuxHeaders;

      gcc = lib.makeOverridable (import ../../build-support/cc-wrapper) {
        nativeTools = false;
        nativeLibc = false;
        isGNU = true;
        cc = stage4.stdenv.cc.cc;
        libc = stage4.pkgs.glibc;
        inherit (stage4.pkgs) binutils coreutils gnugrep;
        name = "";
        stdenv = stage4.stdenv;
        shell = stage4.pkgs.bash + "/bin/bash";
      };
    };
    extraBuildInputs = [ stage3.pkgs.patchelf stage3.pkgs.xz ];
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
      ((import ../common-path.nix) {pkgs = stage4.pkgs;});

    extraBuildInputs = [ stage4.pkgs.patchelf stage4.pkgs.paxctl ];

    cc = stage4.pkgs.gcc;

    shell = cc.shell;

    inherit (stage4.stdenv) fetchurlBoot;

    extraAttrs = {
      inherit (stage4.pkgs) glibc;
      inherit platform bootstrapTools;
      shellPackage = stage4.pkgs.bash;
    };

    allowedRequisites = with stage4.pkgs;
      [ gzip bzip2 xz bash binutils coreutils diffutils findutils gawk
        glibc gnumake gnused gnutar gnugrep gnupatch patchelf attr acl
        paxctl zlib pcre linuxHeaders ed gcc gcc.cc libsigsegv
      ];

    overrides = pkgs: {
      gcc = cc;

      inherit (stage4.pkgs)
        gzip bzip2 xz bash binutils coreutils diffutils findutils gawk
        glibc gnumake gnused gnutar gnugrep gnupatch patchelf
        attr acl paxctl zlib pcre;
    };
  };


  testBootstrapTools = let
    defaultPkgs = allPackages { inherit system platform; };
  in derivation {
    name = "test-bootstrap-tools";
    inherit system;
    builder = bootstrapFiles.busybox;
    args = [ "ash" "-e" "-c" "eval \"$buildCommand\"" ];

    buildCommand = ''
      export PATH=${bootstrapTools}/bin

      ls -l
      mkdir $out
      mkdir $out/bin
      sed --version
      find --version
      diff --version
      patch --version
      make --version
      awk --version
      grep --version
      gcc --version
      curl --version

      ldlinux=$(echo ${bootstrapTools}/lib/ld-linux*.so.?)
      export CPP="cpp -idirafter ${bootstrapTools}/include-glibc -B${bootstrapTools}"
      export CC="gcc -idirafter ${bootstrapTools}/include-glibc -B${bootstrapTools} -Wl,-dynamic-linker,$ldlinux -Wl,-rpath,${bootstrapTools}/lib"
      export CXX="g++ -idirafter ${bootstrapTools}/include-glibc -B${bootstrapTools} -Wl,-dynamic-linker,$ldlinux -Wl,-rpath,${bootstrapTools}/lib"

      echo '#include <stdio.h>' >> foo.c
      echo '#include <limits.h>' >> foo.c
      echo 'int main() { printf("Hello World\\n"); return 0; }' >> foo.c
      $CC -o $out/bin/foo foo.c
      $out/bin/foo

      echo '#include <iostream>' >> bar.cc
      echo 'int main() { std::cout << "Hello World\\n"; }' >> bar.cc
      $CXX -v -o $out/bin/bar bar.cc
      $out/bin/bar

      tar xvf ${defaultPkgs.hello.src}
      cd hello-*
      ./configure --prefix=$out
      make
      make install
    '';
  };
}
