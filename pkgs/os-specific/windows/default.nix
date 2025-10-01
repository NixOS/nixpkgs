{
  lib,
  config,
  stdenv,
  buildPackages,
  pkgs,
  newScope,
  overrideCC,
  stdenvNoLibc,
  emptyDirectory,
}:

lib.makeScope newScope (
  self:
  with self;
  {
    dlfcn = callPackage ./dlfcn { };

    mingw_w64 = callPackage ./mingw-w64 {
      stdenv = stdenvNoLibc;
    };

    # FIXME untested with llvmPackages_16 was using llvmPackages_8
    crossThreadsStdenv = overrideCC stdenvNoLibc (
      if stdenv.hostPlatform.useLLVM or false then
        buildPackages.llvmPackages.clangNoLibcxx
      else
        buildPackages.gccWithoutTargetLibc.override (old: {
          bintools = old.bintools.override {
            libc = pkgs.libc;
          };
          libc = pkgs.libc;
        })
    );

    mingw_w64_headers = callPackage ./mingw-w64/headers.nix { };

    mcfgthreads = callPackage ./mcfgthreads { stdenv = crossThreadsStdenv; };

    npiperelay = callPackage ./npiperelay { };

    pthreads = callPackage ./mingw-w64/pthreads.nix { stdenv = crossThreadsStdenv; };

    libgnurx = callPackage ./libgnurx { };

    sdk = callPackage ./msvcSdk { };
  }
  // lib.optionalAttrs config.allowAliases {
    mingw_w64_pthreads = lib.warn "windows.mingw_w64_pthreads is deprecated, windows.pthreads should be preferred" self.pthreads;
  }
)
