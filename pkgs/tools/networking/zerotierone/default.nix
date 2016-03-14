{ stdenv, fetchurl, openssl, lzo, zlib, gcc, iproute }:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "1.1.4";
  name = "zerotierone";

  src = fetchurl {
    url = "https://github.com/zerotier/ZeroTierOne/archive/${version}.tar.gz";
    sha256 = "10aw0dlkmprdvph3aqkqximxqkryf0l4jcnv2bbm7f1qvclqihva";
  };

  preConfigure = ''
      substituteInPlace ./make-linux.mk \
          --replace 'CC=$(shell which clang gcc cc 2>/dev/null | head -n 1)' "CC=${gcc}/bin/gcc";
      substituteInPlace ./make-linux.mk \
          --replace 'CXX=$(shell which clang++ g++ c++ 2>/dev/null | head -n 1)' "CC=${gcc}/bin/g++";
      substituteInPlace ./osdep/LinuxEthernetTap.cpp \
          --replace 'execlp("ip",' 'execlp("${iproute}/bin/ip",'
  '';

  buildInputs = [ openssl lzo zlib gcc iproute ];

  installPhase = ''
    install -Dt "$out/bin/" zerotier-one
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
