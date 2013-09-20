{ stdenv, fetchurl
}:
  
stdenv.mkDerivation rec {
  name = "mkpasswd-${version}";

  version = "5.0.26";

  src = fetchurl {
    url = "http://ftp.debian.org/debian/pool/main/w/whois/whois_${version}.tar.xz";
    sha256 = "729625ef81425f4771e06492bb4f3e9f24bff75b8176044ce8d2f605f7ad6af5";
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
