{ stdenv, fetchurl }:

let
  imgroot = "https://build.anbox.io/android-images";
in
  {
    armv7l-linux = fetchurl {
      url = imgroot + "/2017/06/12/android_1_armhf.img";
      sha256 = "1za4q6vnj8wgphcqpvyq1r8jg6khz7v6b7h6ws1qkd5ljangf1w5";
    };
    aarch64-linux = fetchurl {
      url = imgroot + "/2017/08/04/android_1_arm64.img";
      sha256 = "02yvgpx7n0w0ya64y5c7bdxilaiqj9z3s682l5s54vzfnm5a2bg5";
    };
    x86_64-linux = fetchurl {
      url = imgroot + "/2018/07/19/android_amd64.img";
      sha256 = "1jlcda4q20w30cm9ikm6bjq01p547nigik1dz7m4v0aps4rws13b";
    };
  }.${stdenv.system} or (throw "Unsupported platform ${stdenv.system}")
