{ pkgs ? import ../../.. {} }:

let
  inherit (pkgs) lib stdenv config;
  libc = pkgs.stdenv.cc.libc;
  patchelf = pkgs.patchelf.overrideAttrs(previousAttrs: {
    NIX_CFLAGS_COMPILE = (previousAttrs.NIX_CFLAGS_COMPILE or []) ++ [ "-static-libgcc" "-static-libstdc++" ];
    NIX_CFLAGS_LINK = (previousAttrs.NIX_CFLAGS_LINK or []) ++ [ "-static-libgcc" "-static-libstdc++" ];
  });
in
rec {
  coreutilsMinimal = pkgs.coreutils.override (args: {
    # We want coreutils without ACL/attr support.
    aclSupport = false;
    attrSupport = false;
    # Our tooling currently can't handle scripts in bin/, only ELFs and symlinks.
    singleBinary = "symlinks";
  });

  tarMinimal = pkgs.gnutar.override { acl = null; };

  busyboxMinimal = pkgs.busybox.override {
    useMusl = lib.meta.availableOn stdenv.hostPlatform pkgs.musl;
    enableStatic = true;
    enableMinimal = true;
    extraConfig = ''
      CONFIG_ASH y
      CONFIG_ASH_ECHO y
      CONFIG_ASH_TEST y
      CONFIG_ASH_OPTIMIZE_FOR_SIZE y
      CONFIG_MKDIR y
      CONFIG_TAR y
      CONFIG_UNXZ y
    '';
  };

  bootGCC = pkgs.gcc.cc.override { enableLTO = false; };
  bootBinutils = pkgs.binutils.bintools.override {
    withAllTargets = false;
    # Don't need two linkers, disable whatever's not primary/default.
    enableGold = false;
    # bootstrap is easier w/static
    enableShared = false;
  };

  build = pkgs.callPackage ./stdenv-bootstrap-tools.nix {
    inherit bootBinutils coreutilsMinimal tarMinimal busyboxMinimal bootGCC libc patchelf;
  };

  inherit (build) bootstrapFiles;

  bootstrapTools =
    let extraAttrs = lib.optionalAttrs
      config.contentAddressedByDefault
      {
        __contentAddressed = true;
        outputHashAlgo = "sha256";
        outputHashMode = "recursive";
      };
    in
    if (stdenv.hostPlatform.libc == "glibc") then
    import ./bootstrap-tools/glibc.nix {
      inherit (stdenv.buildPlatform) system; # Used to determine where to build
      inherit bootstrapFiles extraAttrs;
    }
    else if (stdenv.hostPlatform.libc == "musl") then
    import ./bootstrap-tools/musl.nix {
      inherit (stdenv.buildPlatform) system; # Used to determine where to build
      inherit bootstrapFiles extraAttrs;
    }
    else throw "unsupported libc";

  test = pkgs.callPackage ./test-bootstrap-tools.nix {
    inherit bootstrapTools;
    inherit (bootstrapFiles) busybox;
  };
}
