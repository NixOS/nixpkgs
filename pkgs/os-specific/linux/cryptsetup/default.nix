{ stdenv, fetchurl, fetchpatch, lvm2, json_c
, openssl, libuuid, pkgconfig, popt
, enablePython ? false, python2 ? null }:

assert enablePython -> python2 != null;

stdenv.mkDerivation rec {
  name = "cryptsetup-2.0.3";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/cryptsetup/v2.0/${name}.tar.xz";
    sha256 = "1m01wl8njjraz69fsk97l3nqfc32nbpr1la5s1l4mzzmq42clv2d";
  };

  patches = [
    # NOTE: Patch to support LibreSSL-2.7. It is from upstream, and can be removed when cryptsetup is next updated.
    (fetchpatch {
      url = "https://gitlab.com/cryptsetup/cryptsetup/commit/5fcf430c8105fbeeb07a8cacbae84f941d2a3d55.patch";
      sha256 = "1d3ycsqszq0frlv9r7kmfdfmnk4qa4b4mv25iivmayvpgc8yja7m";
    })
  ];

  postPatch = ''
    patchShebangs tests
  '';

  NIX_LDFLAGS = "-lgcc_s";

  configureFlags = [
    "--disable-kernel_crypto"
    "--enable-cryptsetup-reencrypt"
    "--with-crypto_backend=openssl"
  ] ++ stdenv.lib.optional enablePython "--enable-python";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ lvm2 json_c openssl libuuid popt ]
    ++ stdenv.lib.optional enablePython python2;

  meta = {
    homepage = https://gitlab.com/cryptsetup/cryptsetup/;
    description = "LUKS for dm-crypt";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ chaoflow ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
