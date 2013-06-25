{ stdenv, fetchurl
}:
  
stdenv.mkDerivation rec {
  name = "mkpasswd-${version}";

  version = "5.0.25";

  src = fetchurl {
    url = "http://ftp.debian.org/debian/pool/main/w/whois/whois_${version}.tar.xz";
    sha256 = "0qb859vwd6g93cb5zbf19gpw2g2b9s1qlq4nqia1a966pjkvw1qj";
  };

  preConfigure = ''
    substituteInPlace Makefile --replace "prefix = /usr" "prefix = $out"
  '';

  buildPhase = "make mkpasswd";

  installPhase = "make install-mkpasswd";

  meta = {
    homepage = http://ftp.debian.org/debian/pool/main/w/whois/;
    description = ''
      Overfeatured front end to crypt, from the Debian whois package.
    '';
  };
}
