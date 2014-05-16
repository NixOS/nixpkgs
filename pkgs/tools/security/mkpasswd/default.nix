{ stdenv, fetchurl, perl
}:

stdenv.mkDerivation rec {
  name = "mkpasswd-${version}";

  version = "5.1.2";

  src = fetchurl {
    url = "http://ftp.debian.org/debian/pool/main/w/whois/whois_${version}.tar.xz";
    sha256 = "021f76910e772fa569e299210b36e2eeb20b56dc9ca29edb7e83a21b560a5403";
  };

  buildInputs = [ perl ];

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
