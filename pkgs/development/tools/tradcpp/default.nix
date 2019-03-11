{ stdenv, fetchurl, autoconf }:

stdenv.mkDerivation {
  name = "tradcpp-0.5.2";

  src = fetchurl {
    url = https://ftp.netbsd.org/pub/NetBSD/misc/dholland/tradcpp-0.5.2.tar.gz;
    sha256 = "1h2bwxwc13rz3g2236l89hm47f72hn3m4h7wjir3j532kq0m68bc";
  };

  # tradcpp only comes with BSD-make Makefile; the patch adds configure support
  buildInputs = [ autoconf ];
  preConfigure = "autoconf";
  patches = [
    ./tradcpp-configure.patch
    ./aarch64.patch
  ];

  meta = with stdenv.lib; {
    description = "A traditional (K&R-style) C macro preprocessor";
    platforms = platforms.all;
    license = licenses.bsd2;
  };

}
