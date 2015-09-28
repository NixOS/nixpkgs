{ stdenv, fetchurl, pkgconfig, openssl, pcsclite }:

stdenv.mkDerivation rec {
  name = "yubico-piv-tool-1.0.2";

  src = fetchurl {
    url = "https://developers.yubico.com/yubico-piv-tool/Releases/${name}.tar.gz";
    sha256 = "1l12bkyqs38212rizda6s3mypfr4wdiap0yhqfwx86lqcp4h0yb9";
  };

  buildInputs = [ pkgconfig openssl pcsclite ];

  configureFlags = [ "--with-backend=pcsc" ];

  meta = with stdenv.lib; {
    homepage = https://developers.yubico.com/yubico-piv-tool/;
    description = "";
    maintainers = with maintainers; [ wkennington ];
    license = licenses.bsd2;
    platforms = platforms.all;
  };
}
