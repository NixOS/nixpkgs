{ stdenv, fetchurl, lvm2, json_c
, openssl, libuuid, pkgconfig, popt }:

stdenv.mkDerivation rec {
  pname = "cryptsetup";
  version = "2.3.3";

  outputs = [ "out" "dev" "man" ];

  src = fetchurl {
    url = "mirror://kernel/linux/utils/cryptsetup/v2.3/${pname}-${version}.tar.xz";
    sha256 = "1pw2bq4nv2z3xyycckxkbp7dp9kkp2n6bspna3plryg277z4zjiv";
  };

  # Disable 4 test cases that fail in a sandbox
  patches = [ ./disable-failing-tests.patch ];

  postPatch = ''
    patchShebangs tests

    # O_DIRECT is filesystem dependent and fails in a sandbox (on tmpfs)
    # and on several filesystem types (btrfs, zfs) without sandboxing.
    # Remove it, see discussion in #46151
    substituteInPlace tests/unit-utils-io.c --replace "| O_DIRECT" ""
  '';

  NIX_LDFLAGS = "-lgcc_s";

  configureFlags = [
    "--enable-cryptsetup-reencrypt"
    "--with-crypto_backend=openssl"
  ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ lvm2 json_c openssl libuuid popt ];

  doCheck = true;

  meta = {
    homepage = "https://gitlab.com/cryptsetup/cryptsetup/";
    description = "LUKS for dm-crypt";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
