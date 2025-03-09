{ stdenv, fetchurl }:

let
  imgroot = "https://web.archive.org/web/20211027150924/https://anbox.postmarketos.org";
in
{
  armv7l-linux = fetchurl {
    url = imgroot + "/android-7.1.2_r39.1-anbox_armv7a_neon-userdebug.img";
    sha256 = "1bgzqw4yp52a2q40dr1jlay1nh73jl5mx6wqsxvpb09xghxsng0a";
  };
  aarch64-linux = fetchurl {
    url = imgroot + "/android-7.1.2_r39-anbox_arm64-userdebug.img";
    sha256 = "0dx8mhfcjbkak982zfh65bvy35slz5jk31yl4ara50ryrxsp32nx";
  };
  x86_64-linux = fetchurl {
    url = imgroot + "/android-7.1.2_r39-anbox_x86_64-userdebug.img";
    sha256 = "16vmiz5al2r19wjpd44nagvz7d901ljxdms8gjp2w4xz1d91vzpm";
  };
}
.${stdenv.system} or (throw "Unsupported platform ${stdenv.system}")
