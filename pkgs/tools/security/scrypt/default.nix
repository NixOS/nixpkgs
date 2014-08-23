{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  name = "scrypt-${version}";
  version = "1.1.6";

  src = fetchurl {
    url = "https://www.tarsnap.com/scrypt/scrypt-1.1.6.tgz";
    sha256 = "dfd0d1a544439265bbb9b58043ad3c8ce50a3987b44a61b1d39fd7a3ed5b7fb8";
  };

  buildInputs = [ openssl ];

  meta = {
    description = "The scrypt encryption utility";
    homepage    = https://www.tarsnap.com/scrypt.html;
    license     = stdenv.lib.licenses.bsd2;
    platforms   = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
