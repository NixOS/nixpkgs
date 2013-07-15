{ stdenv, fetchurl, openssl, zlib, e2fsprogs }:

stdenv.mkDerivation {
  name = "tarsnap-1.0.34";

  src = fetchurl {
    url = "https://www.tarsnap.com/download/tarsnap-autoconf-1.0.34.tgz";
    sha256 = "049q0mbz9i4m87n1r78zf62mcxd04wm49rjqpiy5yzy4z8m1gh0l";
  };

  buildInputs = [ openssl zlib e2fsprogs ];

  meta = {
    description = "Online backups for the truly paranoid";
    homepage = "http://www.tarsnap.com/";
    maintainers = with stdenv.lib.maintainers; [roconnor];
  };
}
