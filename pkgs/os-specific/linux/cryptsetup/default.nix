{ stdenv, fetchurl, fetchpatch, lvm2, json_c
, openssl, libuuid, pkgconfig, popt
, enablePython ? false, python2 ? null }:

assert enablePython -> python2 != null;

stdenv.mkDerivation rec {
  name = "cryptsetup-2.0.4";

  outputs = [ "out" "dev" "man" ];

  src = fetchurl {
    url = "mirror://kernel/linux/utils/cryptsetup/v2.0/${name}.tar.xz";
    sha256 = "0d2p9g2wqcv6l3671gvw96p16jadbgyh21ddy2bhqgi96dq3qflx";
  };

  # Disable 4 test cases that fail in a sandbox
  patches = [ ./disable-failing-tests.patch ];

  postPatch = ''
    patchShebangs tests
    ${stdenv.lib.optionalString enablePython ''
      patchShebangs ./python/pycryptsetup-test.py
    ''}

    # O_DIRECT is filesystem dependent and fails in a sandbox (on tmpfs)
    # and on several filesystem types (btrfs, zfs) without sandboxing.
    # Remove it, see discussion in #46151
    substituteInPlace tests/unit-utils-io.c --replace "| O_DIRECT" ""
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

  doCheck = true;

  meta = {
    homepage = https://gitlab.com/cryptsetup/cryptsetup/;
    description = "LUKS for dm-crypt";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ chaoflow ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
