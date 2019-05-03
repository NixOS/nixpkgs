{ stdenv, stdenv49, gcc9Stdenv, llvmPackages_8
, lib, fetchurl, fetchpatch, fetchFromGitHub

, cmake, ninja, which, findutils, m4, gawk
, python, python3, openjdk, mono, libressl, boost
}@args:

let
  vsmakeBuild = import ./vsmake.nix args;
  cmakeBuild = import ./cmake.nix (args // {
    gccStdenv    = gcc9Stdenv;
    llvmPackages = llvmPackages_8;
  });

  python3-six-patch = fetchpatch {
    name   = "update-python-six.patch";
    url    = "https://github.com/apple/foundationdb/commit/4bd9efc4fc74917bc04b07a84eb065070ea7edb2.patch";
    sha256 = "030679lmc86f1wzqqyvxnwjyfrhh54pdql20ab3iifqpp9i5mi85";
  };

  python3-print-patch = fetchpatch {
    name   = "import-for-python-print.patch";
    url    = "https://github.com/apple/foundationdb/commit/ded17c6cd667f39699cf663c0e87fe01e996c153.patch";
    sha256 = "11y434w68cpk7shs2r22hyrpcrqi8vx02cw7v5x79qxvnmdxv2an";
  };

in with builtins; {

  # Older versions use the bespoke 'vsmake' build system
  # ------------------------------------------------------

  foundationdb51 = vsmakeBuild rec {
    version = "5.1.7";
    branch  = "release-5.1";
    sha256  = "1rc472ih24f9s5g3xmnlp3v62w206ny0pvvw02bzpix2sdrpbp06";

    patches = [
      ./patches/ldflags-5.1.patch
      ./patches/fix-scm-version.patch
      python3-six-patch
      python3-print-patch
    ];
  };

  foundationdb52 = vsmakeBuild rec {
    version = "5.2.8";
    branch  = "release-5.2";
    sha256  = "1kbmmhk2m9486r4kyjlc7bb3wd50204i0p6dxcmvl6pbp1bs0wlb";

    patches = [
      ./patches/ldflags-5.2.patch
      ./patches/fix-scm-version.patch
      python3-six-patch
      python3-print-patch
    ];
  };

  foundationdb60 = vsmakeBuild rec {
    version = "6.0.18";
    branch  = "release-6.0";
    sha256  = "0q1mscailad0z7zf1nypv4g7gx3damfp45nf8nzyq47nsw5gz69p";

    patches = [
      ./patches/ldflags-6.0.patch
    ];
  };

  # 6.1 and later versions should always use CMake
  # ------------------------------------------------------

  foundationdb61 = cmakeBuild rec {
    version = "6.1.6pre4898_${substring 0 7 rev}";
    branch  = "release-6.1";
    rev     = "26fbbbf798971b2b9ecb882a8af766fa36734f53";
    sha256  = "1q1a1j8h0qlh67khcds0dg416myvjbp6gfm6s4sk8d60zfzny7wb";
    officialRelease = false;

    patches = [
      ./patches/clang-libcxx.patch
      ./patches/suppress-clang-warnings.patch
    ];
  };

}
