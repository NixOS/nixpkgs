{ lib, stdenv, buildPackages
, newScope, overrideCC, crossLibcStdenv, libcCross
}:

lib.makeScope newScope (self: with self; {

  cygwinSetup = callPackage ./cygwin-setup { };

  dlfcn = callPackage ./dlfcn { };

  w32api = callPackage ./w32api { };

  mingwrt = callPackage ./mingwrt { };
  mingw_runtime = mingwrt;

  mingw_w64 = callPackage ./mingw-w64 {
    stdenv = crossLibcStdenv;
  };

  # FIXME untested with llvmPackages_16 was using llvmPackages_8
  crossThreadsStdenv = overrideCC crossLibcStdenv
    (if stdenv.hostPlatform.useLLVM or false
     then buildPackages.llvmPackages.clangNoLibcxx
     else buildPackages.gccWithoutTargetLibc.override (old: {
       bintools = old.bintools.override {
         libc = libcCross;
       };
       libc = libcCross;
     }));

  mingw_w64_headers = callPackage ./mingw-w64/headers.nix { };

  mingw_w64_pthreads = callPackage ./mingw-w64/pthreads.nix {
    stdenv = crossThreadsStdenv;
  };

  mcfgthreads = callPackage ./mcfgthreads {
    stdenv = crossThreadsStdenv;
  };

  npiperelay = callPackage ./npiperelay { };

  pthreads = callPackage ./pthread-w32 { };

  libgnurx = callPackage ./libgnurx { };
})
