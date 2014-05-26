{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "mkpasswd-${version}";

  version = "5.1.1";

  src = fetchFromGitHub {
    owner = "rfc1036";
    repo = "whois";
    rev = "v${version}";
    sha256 = "026x8byx8pcpkdxca64368p0nlspk4phw18jg4p04di6cg6nc1m5";
  };

  preConfigure = ''
    substituteInPlace Makefile --replace "prefix = /usr" "prefix = $out"
  '';

  buildPhase = "make mkpasswd";

  installPhase = "make install-mkpasswd";

  meta = with stdenv.lib; {
    homepage = http://packages.qa.debian.org/w/whois.html;
    description = "Overfeatured front-end to crypt, from the Debian whois package";
    license = licenses.gpl2;
    maintainers = [ maintainers.cstrahan ];
    platforms = platforms.linux;
  };
}
