{ stdenv, fetchurl, pkgconfig, perl, perlPackages, bison, flex, openssl, jansson, cyrus_sasl, icu, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "cyrus-imapd";
  version = "3.0.12";

  src = fetchurl {
    url = "https://www.cyrusimap.org/releases/${pname}-${version}.tar.gz";
    sha256 = "1lqb5y662fyad7hw1184ldwhz89cdl9d6bjrpjvdhvziy5i6866l";
  };

  nativeBuildInputs = [ pkgconfig flex bison perl makeWrapper ];
  buildInputs = [ openssl jansson cyrus_sasl icu ];

  postFixup = ''
    for prog in installsieve sieveshell cyradm
    do
      wrapProgram $out/bin/$prog \
          --set PATH ${stdenv.lib.makeBinPath [ perl ]} \
          --set PERL5LIB "$PERL5LIB:$out/${perl.libPrefix}"
    done
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.cyrusimap.org/imap/";
    description = "An email, contacts and calendar server";
    license = licenses.bsdOriginal;
    platforms = platforms.unix;
    maintainers = with maintainers; [ petabyteboy ];
  };
}
