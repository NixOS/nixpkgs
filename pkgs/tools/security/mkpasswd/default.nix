{ stdenv, whois, perl }:

stdenv.mkDerivation {
  name = "mkpasswd-${whois.version}";

  src = whois.src;

  nativeBuildInputs = [ perl ];

  preConfigure = whois.preConfigure;
  buildPhase = "make mkpasswd";
  installPhase = "make install-mkpasswd";

  meta = with stdenv.lib; {
    homepage = https://packages.qa.debian.org/w/whois.html;
    description = "Overfeatured front-end to crypt, from the Debian whois package";
    license = licenses.gpl2;
    maintainers = with maintainers; [ cstrahan fpletz ];
    platforms = platforms.linux;
  };
}
