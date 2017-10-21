{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "banner-1.3.4";

  src = fetchurl {
    url = "http://software.cedar-solutions.com/ftp/software/${name}.tar.gz";
    sha256 = "04q5ribr0r9s8waky3nk356l0qdhfxw15ipz7lsfgv1fxq3qk6bz";
  };

  meta = with stdenv.lib; {
    homepage = http://software.cedar-solutions.com/utilities.html;
    description = "Print large banners to ASCII terminals";
    license = licenses.gpl2;

    longDescription = ''
      An implementation of the traditional Unix-program used to display
      large characters.
    '';

    platforms = platforms.all;
    maintainers = with maintainers; [ pSub ];
  };
}
