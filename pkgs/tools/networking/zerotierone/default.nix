{ stdenv, fetchurl, openssl, lzo, zlib, gcc, iproute, ronn }:

stdenv.mkDerivation rec {
  version = "1.1.6";
  name = "zerotierone";

  src = fetchurl {
    url = "https://github.com/zerotier/ZeroTierOne/archive/${version}.tar.gz";
    sha256 = "1bl8dppaqydsd1qf9pk3bp16amkwjxyqh1gvm62ys2a0m4c529ks";
  };

  preConfigure = ''
      substituteInPlace ./make-linux.mk \
        --replace 'CC=$(shell which clang gcc cc 2>/dev/null | head -n 1)' "CC=${gcc}/bin/gcc";
      substituteInPlace ./make-linux.mk \
        --replace 'CXX=$(shell which clang++ g++ c++ 2>/dev/null | head -n 1)' "CC=${gcc}/bin/g++";
      substituteInPlace ./osdep/LinuxEthernetTap.cpp \
        --replace 'execlp("ip",' 'execlp("${iproute}/bin/ip",'

      patchShebangs ./doc/build.sh
      substituteInPlace ./doc/build.sh \
        --replace '/usr/bin/ronn' '${ronn}/bin/ronn' \
        --replace 'ronn -r' '${ronn}/bin/ronn -r'
  '';

  buildInputs = [ openssl lzo zlib gcc iproute ronn ];

  installPhase = ''
    install -Dt "$out/bin/" zerotier-one
    ln -s $out/bin/zerotier-one $out/bin/zerotier-idtool
    ln -s $out/bin/zerotier-one $out/bin/zerotier-cli

    mkdir -p $man/share/man/man8
    for cmd in zerotier-one.8 zerotier-cli.1 zerotier-idtool.1; do
      cat doc/$cmd | gzip -9 > $man/share/man/man8/$cmd.gz
    done
  '';

  outputs = [ "out" "man" ];

  meta = with stdenv.lib; {
    description = "Create flat virtual Ethernet networks of almost unlimited size";
    homepage = https://www.zerotier.com;
    license = licenses.gpl3;
    maintainers = [ sjmackenzie ];
    platforms = platforms.allBut [ "i686-linux" ];
  };
}
