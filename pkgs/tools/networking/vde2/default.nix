{ stdenv, fetchurl, fetchpatch, openssl, libpcap, python2, withPython ? false }:

stdenv.mkDerivation rec {
  name = "vde2-2.3.2";

  src = fetchurl {
    url = "mirror://sourceforge/vde/vde2/2.3.1/${name}.tar.gz";
    sha256 = "14xga0ib6p1wrv3hkl4sa89yzjxv7f1vfqaxsch87j6scdm59pr2";
  };

  patches = [
    # Fix build with openssl 1.1.0
    (fetchpatch {
      name = "vde_cryptcab-compile-against-openssl-1.1.0.patch";
      url = "https://git.archlinux.org/svntogit/packages.git/plain/trunk/vde_cryptcab-compile-against-openssl-1.1.0.patch?h=packages/vde2&id=15b11be49997fa94b603e366064690b7cc6bce61";
      sha256 = "07z1yabwigq35mkwzqa934n7vjnjlqz5xfzq8cfj87lgyjjp00qi";
    })
  ] ++ stdenv.lib.optional stdenv.hostPlatform.isMusl [
    (fetchpatch {
      url = "https://git.alpinelinux.org/cgit/aports/plain/main/vde2/musl-build-fix.patch?id=ddee2f86a48e087867d4a2c12849b2e3baccc238";
      sha256 = "0b5382v541bkxhqylilcy34bh83ag96g71f39m070jzvi84kx8af";
    })
  ];

  configureFlags = stdenv.lib.optional (!withPython) "--disable-python";

  buildInputs = [ openssl libpcap ]
    ++ stdenv.lib.optional withPython python2;

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/virtualsquare/vde-2";
    description = "Virtual Distributed Ethernet, an Ethernet compliant virtual network";
    platforms = platforms.unix;
    license = licenses.gpl2;
  };
}
