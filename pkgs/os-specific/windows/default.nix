{
  lib,
  config,
  stdenv,
  __splicedPackages,
  pkgs,
  newScope,
  overrideCC,
  stdenvNoLibc,
  makeScopeWithSplicing',
  generateSplicesForMkScope,
}:

makeScopeWithSplicing' {
  otherSplices = generateSplicesForMkScope "windows";
  f =
    self:
    let
      inherit (self) callPackage;
      pkgs = __splicedPackages;
    in
    {
      dlfcn = callPackage ./dlfcn { };

      mingw_w64 = callPackage ./mingw-w64 {
        stdenv = pkgs.stdenvNoLibc;
      };

      # FIXME untested with llvmPackages_16 was using llvmPackages_8
      crossThreadsStdenv = pkgs.overrideCC pkgs.stdenvNoLibc (
        if pkgs.buildPackages.stdenv.hostPlatform.useLLVM or false then
          pkgs.buildPackages.llvmPackages.clangNoLibcxx
        else
          pkgs.buildPackages.gccWithoutTargetLibc.override (old: {
            bintools = old.bintools.override {
              libc = pkgs.libc;
            };
            libc = pkgs.libc;
          })
      );

      mingw_w64_headers = callPackage ./mingw-w64/headers.nix { };

      mcfgthreads = callPackage ./mcfgthreads { stdenv = self.crossThreadsStdenv; };

      npiperelay = callPackage ./npiperelay { };

      pthreads = callPackage ./mingw-w64/pthreads.nix { stdenv = self.crossThreadsStdenv; };

      libgnurx = callPackage ./libgnurx { };

      sdk = callPackage ./msvcSdk { };
    }
    // lib.optionalAttrs config.allowAliases {
      mingw_w64_pthreads = lib.warn "windows.mingw_w64_pthreads is deprecated, windows.pthreads should be preferred" self.pthreads;
    };
}
