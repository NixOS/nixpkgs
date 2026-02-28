{
  localSystem,
  config,
  lib,
}:
let
  minbootBuildPlatform = lib.systems.elaborate (
    {
      i686-linux = "i686-unknown-linux-musl";
      x86_64-linux = "x86_64-unknown-linux-musl";
    }
    .${localSystem.system} or "x86_64-unknown-linux-musl"
  );
in
let
  callPackage = lib.callPackageWith { inherit lib config; };
  minimal-bootstrap = lib.recurseIntoAttrs (
    import ../../os-specific/linux/minimal-bootstrap {
      buildPlatform = minbootBuildPlatform;
      hostPlatform = localSystem;
      inherit lib config;
      fetchurl = import ../../build-support/fetchurl/boot.nix {
        system = localSystem;
        inherit (config) rewriteURL;
      };
      checkMetaBuild = callPackage ../generic/check-meta.nix { hostPlatform = minbootBuildPlatform; };
      checkMetaHost = callPackage ../generic/check-meta.nix { hostPlatform = localSystem; };
    }
  );
  compilerPackage = minimal-bootstrap.gcc;
  libcPackage = minimal-bootstrap.libc;
in
assert minimal-bootstrap.bash-static.passthru.isFromMinBootstrap or false; # sanity check
{
  inherit minimal-bootstrap;
  isMinimalBootstrap = true;

  dummyStdenv = {
    name = "bootstrap-stage0";

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
      ${localSystem.libc} = self.stdenv.mkDerivation {
        pname = "bootstrap-stage0-${localSystem.libc}";
        strictDeps = true;
        version = "minimal-bootstrap";
        enableParallelBuilding = true;
        buildCommand = ''
          mkdir -p $out
          ln -s ${libcPackage}/lib $out/lib
          ln -s ${libcPackage}/include $out/include
        '';
        passthru.isFromBootstrapFiles = true;
      };
      gcc-unwrapped = compilerPackage;
      binutils = import ../../build-support/bintools-wrapper {
        name = "bootstrap-stage0-binutils-wrapper";
        nativeTools = false;
        nativeLibc = false;
        expand-response-params = "";
        inherit lib;
        inherit (self)
          stdenvNoCC
          coreutils
          gnugrep
          libc
          ;
        bintools = minimal-bootstrap.binutils-static;
        runtimeShell = "${minimal-bootstrap.bash}/bin/bash";
      };
      coreutils = minimal-bootstrap.coreutils-static;
      gnugrep = minimal-bootstrap.gnugrep-static;
    };
  };
  bash = minimal-bootstrap.bash-static;
  initialPath = with minimal-bootstrap; [
    bash-static
    binutils-static
    bzip2-static
    compilerPackage
    coreutils-static
    diffutils-static
    findutils-static
    gawk-static
    gnugrep-static
    gnumake-static
    gnupatch-static
    gnused-static
    gnutar-static
    gzip-static
    patchelf-static
    xz-static
  ];
  disallowedInFinalStdenv = lib.attrsets.catAttrs "out" (
    builtins.filter (drv: lib.attrsets.isDerivation drv) (builtins.attrValues minimal-bootstrap)
  );
}
