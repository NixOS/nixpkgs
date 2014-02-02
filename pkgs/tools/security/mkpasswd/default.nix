{ stdenv, fetchurl
}:
  
stdenv.mkDerivation rec {
  name = "mkpasswd-${version}";

  version = "5.1.1";

  src = fetchurl {
    url = "http://ftp.debian.org/debian/pool/main/w/whois/whois_${version}.tar.xz";
    sha256 = "0i06a9mb9qcq272782mg6dffv3k7bqkw4cdr31yrc0s6jqylryv9";
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
