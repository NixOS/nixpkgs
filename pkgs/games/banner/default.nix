{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "banner-1.3.3";

  src = fetchurl {
    url = "http://software.cedar-solutions.com/ftp/software/${name}.tar.gz";
    sha256 = "1njbgba0gzvrmdkvfjgrnvj0i80yi8k7mpkgyxaj07bmv9kc3h5v";
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
