{ lib, stdenv, buildPackages
, newScope, overrideCC, crossLibcStdenv, libcCross
}:

lib.makeScope newScope (self: with self; {

  cygwinSetup = callPackage ./cygwin-setup { };

<<<<<<< HEAD
  dlfcn = callPackage ./dlfcn { };
=======
  jom = callPackage ./jom { };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  w32api = callPackage ./w32api { };

  mingwrt = callPackage ./mingwrt { };
  mingw_runtime = mingwrt;

  mingw_w64 = callPackage ./mingw-w64 {
    stdenv = crossLibcStdenv;
  };

  crossThreadsStdenv = overrideCC crossLibcStdenv
    (if stdenv.hostPlatform.useLLVM or false
     then buildPackages.llvmPackages_8.clangNoLibcxx
<<<<<<< HEAD
     else buildPackages.gccWithoutTargetLibc.override (old: {
=======
     else buildPackages.gccCrossStageStatic.override (old: {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
       bintools = old.bintools.override {
         libc = libcCross;
       };
       libc = libcCross;
     }));

  mingw_w64_headers = callPackage ./mingw-w64/headers.nix { };

  mingw_w64_pthreads = callPackage ./mingw-w64/pthreads.nix {
    stdenv = crossThreadsStdenv;
  };

<<<<<<< HEAD
  mcfgthreads_pre_gcc_13 = callPackage ./mcfgthreads/pre_gcc_13.nix {
    stdenv = crossThreadsStdenv;
  };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  mcfgthreads = callPackage ./mcfgthreads {
    stdenv = crossThreadsStdenv;
  };

  npiperelay = callPackage ./npiperelay { };

  pthreads = callPackage ./pthread-w32 { };

  wxMSW = callPackage ./wxMSW-2.8 { };

  libgnurx = callPackage ./libgnurx { };
})
