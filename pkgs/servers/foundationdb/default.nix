{ gcc6Stdenv, gccStdenv, llvmPackages
, lib, fetchurl, fetchpatch, fetchFromGitHub

, cmake, ninja, which, findutils, m4, gawk
, python2, python3, openjdk, mono, libressl, boost168
}@args:

let
  vsmakeBuild = import ./vsmake.nix args;
  cmakeBuild = import ./cmake.nix (args // {
    gccStdenv    = gccStdenv;
    llvmPackages = llvmPackages;
    boost        = boost168;
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

  glibc230-fix = fetchpatch {
    url = "https://github.com/Ma27/foundationdb/commit/e133cb974b9a9e4e1dc2d4ac15881d31225c0197.patch";
    sha256 = "1v9q2fyc73msigcykjnbmfig45zcrkrzcg87b0r6mxpnby8iryl1";
  };

in with builtins; {

  # Older versions use the bespoke 'vsmake' build system
  # ------------------------------------------------------

  foundationdb51 = vsmakeBuild {
    version = "5.1.7";
    branch  = "release-5.1";
    sha256  = "1rc472ih24f9s5g3xmnlp3v62w206ny0pvvw02bzpix2sdrpbp06";

    patches = [
      ./patches/ldflags-5.1.patch
      ./patches/fix-scm-version.patch
      ./patches/gcc-fixes.patch
      python3-six-patch
      python3-print-patch
    ];
  };

  foundationdb52 = vsmakeBuild {
    version = "5.2.8";
    branch  = "release-5.2";
    sha256  = "1kbmmhk2m9486r4kyjlc7bb3wd50204i0p6dxcmvl6pbp1bs0wlb";

    patches = [
      ./patches/ldflags-5.2.patch
      ./patches/fix-scm-version.patch
      ./patches/gcc-fixes.patch
      python3-six-patch
      python3-print-patch
    ];
  };

  foundationdb60 = vsmakeBuild {
    version = "6.0.18";
    branch  = "release-6.0";
    sha256  = "0q1mscailad0z7zf1nypv4g7gx3damfp45nf8nzyq47nsw5gz69p";

    patches = [
      ./patches/ldflags-6.0.patch
      ./patches/include-fixes-6.0.patch
    ];
  };

  # 6.1 and later versions should always use CMake
  # ------------------------------------------------------

  foundationdb61 = cmakeBuild {
    version = "6.1.13";
    branch  = "release-6.1";
    sha256  = "10vd694dcnh2pp91mri1m80kfbwjanhiy50c53c5ncqfa6pwvk00";

    patches = [
      ./patches/clang-libcxx.patch
      ./patches/suppress-clang-warnings.patch
      ./patches/stdexcept-6.1.patch
      glibc230-fix
    ];
  };

}
