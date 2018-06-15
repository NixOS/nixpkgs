{ stdenv, fetchurl, fetchpatch, openssl, libpcap, python2 }:

stdenv.mkDerivation rec {
  name = "vde2-2.3.2";

  src = fetchurl {
    url = "mirror://sourceforge/vde/vde2/2.3.1/${name}.tar.gz";
    sha256 = "14xga0ib6p1wrv3hkl4sa89yzjxv7f1vfqaxsch87j6scdm59pr2";
  };

  patches = stdenv.lib.optional stdenv.hostPlatform.isMusl (
    fetchpatch {
      url = "https://git.alpinelinux.org/cgit/aports/plain/main/vde2/musl-build-fix.patch?id=ddee2f86a48e087867d4a2c12849b2e3baccc238";
      sha256 = "0b5382v541bkxhqylilcy34bh83ag96g71f39m070jzvi84kx8af";
    }
  );


  buildInputs = [ openssl libpcap python2 ];

  hardeningDisable = [ "format" ];

  meta = {
    homepage = http://vde.sourceforge.net/;
    description = "Virtual Distributed Ethernet, an Ethernet compliant virtual network";
    platforms = stdenv.lib.platforms.unix;
  };
}
