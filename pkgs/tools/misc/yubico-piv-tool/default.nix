{ stdenv, fetchurl, pkgconfig, openssl, pcsclite }:

stdenv.mkDerivation rec {
  name = "yubico-piv-tool-0.1.5";

  src = fetchurl {
    url = "https://developers.yubico.com/yubico-piv-tool/Releases/${name}.tar.gz";
    sha256 = "1zii90f0d1j9cinvxqlzs9h8w7a856ksd8ghgqz12jywmjz0blxq";
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
