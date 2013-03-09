{ stdenv, fetchurl
}:
  
stdenv.mkDerivation rec {
  name = "mkpasswd-${version}";

  version = "5.0.20";

  src = fetchurl {
    url = "http://ftp.debian.org/debian/pool/main/w/whois/whois_${version}.tar.xz";
    sha256 = "1kwf5pwc7w8dw40nrd4m4637mz7pbhc4c1v78j56nqj38sak50w1";
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
