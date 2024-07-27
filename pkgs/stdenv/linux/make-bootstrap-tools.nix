{ pkgs ? import ../../.. {} }:

let
  libc = pkgs.stdenv.cc.libc;
  patchelf = pkgs.patchelf.overrideAttrs(previousAttrs: {
    NIX_CFLAGS_COMPILE = (previousAttrs.NIX_CFLAGS_COMPILE or []) ++ [ "-static-libgcc" "-static-libstdc++" ];
    NIX_CFLAGS_LINK = (previousAttrs.NIX_CFLAGS_LINK or []) ++ [ "-static-libgcc" "-static-libstdc++" ];
  });
in with pkgs; rec {


  coreutilsMinimal = coreutils.override (args: {
    # We want coreutils without ACL/attr support.
    aclSupport = false;
    attrSupport = false;
    # Our tooling currently can't handle scripts in bin/, only ELFs and symlinks.
    singleBinary = "symlinks";
  });

  tarMinimal = gnutar.override { acl = null; };

  busyboxMinimal = busybox.override {
    useMusl = lib.meta.availableOn stdenv.hostPlatform musl;
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

  bootGCC = gcc.cc.override { enableLTO = false; };
  bootBinutils = binutils.bintools.override {
    withAllTargets = false;
    # Don't need two linkers, disable whatever's not primary/default.
    enableGold = false;
    # bootstrap is easier w/static
    enableShared = false;
  };

  build = callPackage ./stdenv-bootstrap-tools.nix {
    inherit bootBinutils coreutilsMinimal tarMinimal busyboxMinimal bootGCC libc patchelf;
  };

  bootstrapFiles = {
    # Make them their own store paths to test that busybox still works when the binary is named /nix/store/HASH-busybox
    busybox = runCommand "busybox" {} "cp ${build}/on-server/busybox $out";
    bootstrapTools = runCommand "bootstrap-tools.tar.xz" {} "cp ${build}/on-server/bootstrap-tools.tar.xz $out";
  };

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
    import ./bootstrap-tools {
      inherit (stdenv.buildPlatform) system; # Used to determine where to build
      inherit bootstrapFiles extraAttrs;
    }
    else if (stdenv.hostPlatform.libc == "musl") then
    import ./bootstrap-tools-musl {
      inherit (stdenv.buildPlatform) system; # Used to determine where to build
      inherit bootstrapFiles extraAttrs;
    }
    else throw "unsupported libc";

  test = callPackage ./test-bootstrap-tools.nix {
    inherit bootstrapTools;
    inherit (bootstrapFiles) busybox;
  };
}
