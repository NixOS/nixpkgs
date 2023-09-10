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

  crossThreadsStdenv = overrideCC crossLibcStdenv
    (if stdenv.hostPlatform.useLLVM or false
     then buildPackages.llvmPackages_8.clangNoLibcxx
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

  mcfgthreads_pre_gcc_13 = callPackage ./mcfgthreads/pre_gcc_13.nix {
    stdenv = crossThreadsStdenv;
  };

  mcfgthreads = callPackage ./mcfgthreads {
    stdenv = crossThreadsStdenv;
  };

  npiperelay = callPackage ./npiperelay { };

  pthreads = callPackage ./pthread-w32 { };

  wxMSW = callPackage ./wxMSW-2.8 { };

  libgnurx = callPackage ./libgnurx { };
})
