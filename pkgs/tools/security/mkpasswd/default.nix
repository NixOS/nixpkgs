{ stdenv, fetchurl, perl
}:
  
stdenv.mkDerivation rec {
  name = "mkpasswd-${version}";

  version = "5.1.2";

  src = fetchurl {
    url = "http://ftp.debian.org/debian/pool/main/w/whois/whois_${version}.tar.xz";
    sha256 = "00sl19b1p8l3gvdrx8lwvib0pcpfw8v0n8crw9lsabvp1s8pc7q2";
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
