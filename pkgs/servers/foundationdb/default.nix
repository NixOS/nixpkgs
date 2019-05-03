{ stdenv49
, lib, fetchurl, fetchpatch, fetchFromGitHub

, which, findutils, m4, gawk
, python, openjdk, mono, libressl
}@args:

let
  vsmake = import ./vsmake.nix args;
in with builtins; {
  foundationdb51 = vsmake rec {
    version = "5.1.7";
    branch  = "release-5.1";
    sha256  = "1rc472ih24f9s5g3xmnlp3v62w206ny0pvvw02bzpix2sdrpbp06";
  };

  foundationdb52 = vsmake rec {
    version = "5.2.8";
    branch  = "release-5.2";
    sha256  = "1kbmmhk2m9486r4kyjlc7bb3wd50204i0p6dxcmvl6pbp1bs0wlb";
  };

  foundationdb60 = vsmake rec {
    version = "6.0.18";
    branch  = "release-6.0";
    sha256  = "0q1mscailad0z7zf1nypv4g7gx3damfp45nf8nzyq47nsw5gz69p";
  };
}
