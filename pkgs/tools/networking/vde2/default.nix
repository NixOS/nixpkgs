{ lib, stdenv, fetchurl, fetchpatch, openssl, libpcap, python2, withPython ? false }:

stdenv.mkDerivation rec {
  pname = "vde2";
  version = "2.3.2";

  src = fetchurl {
    url = "mirror://sourceforge/vde/vde2/${version}/vde2-${version}.tar.gz";
    sha256 = "14xga0ib6p1wrv3hkl4sa89yzjxv7f1vfqaxsch87j6scdm59pr2";
  };

  patches = [
    # Fix build with openssl 1.1.0
    (fetchpatch {
      name = "vde_cryptcab-compile-against-openssl-1.1.0.patch";
      url = "https://raw.githubusercontent.com/archlinux/svntogit-packages/15b11be49997fa94b603e366064690b7cc6bce61/trunk/vde_cryptcab-compile-against-openssl-1.1.0.patch";
      sha256 = "07z1yabwigq35mkwzqa934n7vjnjlqz5xfzq8cfj87lgyjjp00qi";
    })
  ] ++ lib.optional stdenv.hostPlatform.isMusl [
    (fetchpatch {
      url = "https://git.alpinelinux.org/aports/plain/main/vde2/musl-build-fix.patch?id=ddee2f86a48e087867d4a2c12849b2e3baccc238";
      sha256 = "0b5382v541bkxhqylilcy34bh83ag96g71f39m070jzvi84kx8af";
    })
  ];

  preConfigure = lib.optionalString (lib.versionAtLeast stdenv.hostPlatform.darwinMinVersion "11") ''
    MACOSX_DEPLOYMENT_TARGET=10.16
  '';

  configureFlags = lib.optional (!withPython) "--disable-python";

  buildInputs = [ openssl libpcap ]
    ++ lib.optional withPython python2;

  hardeningDisable = [ "format" ];

  # Disable parallel build as it fails as:
  #   make: *** No rule to make target '../../src/lib/libvdemgmt.la',
  #    needed by 'libvdesnmp.la'.  Stop.
  # Next release should address it with
  #     https://github.com/virtualsquare/vde-2/commit/7dd9ed46d5dca125ca45d679ac9f3acbfb0f9300.patch
  enableParallelBuilding = false;

  meta = with lib; {
    homepage = "https://github.com/virtualsquare/vde-2";
    description = "Virtual Distributed Ethernet, an Ethernet compliant virtual network";
    platforms = platforms.unix;
    license = licenses.gpl2;
  };
}
