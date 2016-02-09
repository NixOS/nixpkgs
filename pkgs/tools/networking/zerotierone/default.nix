{ stdenv, fetchurl, openssl, lzo, zlib, gcc, iproute }:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "1.1.0";
  name = "zerotierone";

  src = fetchurl {
    url = "https://github.com/zerotier/ZeroTierOne/archive/${version}.tar.gz";
    sha256 = "2d7ff178bd7fd284ebb7011d8a91bde51befda60f100eb5429a2dcb6626cf676";
  };

  preConfigure = ''
      substituteInPlace ./make-linux.mk \
          --replace 'CC=$(shell which clang gcc cc 2>/dev/null | head -n 1)' "CC=${gcc}/bin/gcc";
      substituteInPlace ./make-linux.mk \
          --replace 'CXX=$(shell which clang++ g++ c++ 2>/dev/null | head -n 1)' "CC=${gcc}/bin/g++";
      substituteInPlace ./osdep/LinuxEthernetTap.cpp \
          --replace '/sbin/ip' "${iproute}/bin/ip"
  '';

  buildInputs = [ openssl lzo zlib gcc iproute ];

  installPhase = ''
    installBin zerotier-one
    ln -s $out/bin/zerotier-one $out/bin/zerotier-idtool
    ln -s $out/bin/zerotier-one $out/bin/zerotier-cli
  '';

  meta = {
    description = "Create flat virtual Ethernet networks of almost unlimited size";
    homepage = https://www.zerotier.com;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.sjmackenzie ];
    platforms = with stdenv.lib; platforms.allBut [ "i686-linux" ];
  };
}
