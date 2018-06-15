{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "0.4.3";
  name = "dateutils-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/hroptatyr/dateutils/downloads/${name}.tar.xz";
    sha256 = "06lgqp2cyvmh09j04lm3g6ml7yxn1x92rjzgnwzq4my95c37kmdh";
  };

  meta = with stdenv.lib; {
    description = "A bunch of tools that revolve around fiddling with dates and times in the command line";
    homepage = http://www.fresse.org/dateutils/;
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.paperdigits ];
  };
}
