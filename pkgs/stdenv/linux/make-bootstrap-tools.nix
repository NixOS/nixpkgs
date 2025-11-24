{
  pkgs ? import ../../.. { },
}:

let
  inherit (pkgs)
    lib
    stdenv
    config
    libc
    ;

  patchelf = pkgs.patchelf.overrideAttrs (previousAttrs: {
    NIX_CFLAGS_COMPILE = (previousAttrs.NIX_CFLAGS_COMPILE or [ ]) ++ [
      "-static-libgcc"
      "-static-libstdc++"
    ];
    NIX_CFLAGS_LINK = (previousAttrs.NIX_CFLAGS_LINK or [ ]) ++ [
      "-static-libgcc"
      "-static-libstdc++"
    ];
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

  bootGCC =
    (pkgs.gcc.cc.override {
      enableLTO = false;
      isl = null;
    }).overrideAttrs
      (old: {
        patches = old.patches or [ ] ++ [
          (pkgs.fetchpatch {
            # c++tools: Don't check --enable-default-pie.
            # --enable-default-pie breaks bootstrap gcc otherwise, because libiberty.a is not found
            url = "https://github.com/gcc-mirror/gcc/commit/3f1f99ef82a65d66e3aaa429bf4fb746b93da0db.patch";
            hash = "sha256-wKVuwrW22gSN1woYFYxsyVk49oYmbogIN6FWbU8cVds=";
          })
        ];
      });

  bootBinutils = pkgs.binutils.bintools.override {
    withAllTargets = false;
    # Don't need two linkers, disable whatever's not primary/default.
    enableGold = false;
    # bootstrap is easier w/static
    enableShared = false;
  };

  build = pkgs.callPackage ./stdenv-bootstrap-tools.nix {
    inherit
      bootBinutils
      coreutilsMinimal
      tarMinimal
      busyboxMinimal
      bootGCC
      libc
      patchelf
      ;
  };

  inherit (build) bootstrapFiles;

  bootstrapTools = import ./bootstrap-tools {
    inherit (stdenv.buildPlatform) system; # Used to determine where to build
    inherit (stdenv.hostPlatform) libc;
    inherit lib bootstrapFiles config;
  };

  test = pkgs.callPackage ./test-bootstrap-tools.nix {
    inherit bootstrapTools;
    inherit (bootstrapFiles) busybox;
  };
}
