{ stdenv, fetchurl, pkgconfig, openssl, pcsclite }:

stdenv.mkDerivation rec {
  name = "yubico-piv-tool-0.1.0";

  src = fetchurl {
    url = "https://developers.yubico.com/yubico-piv-tool/Releases/${name}.tar.gz";
    sha256 = "1m573f0vn3xgzsl29ps679iykp5krwd0fnr4nhm1fw2hm5zahrhf";
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
