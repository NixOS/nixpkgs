{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "0.4.1";
  name = "dateutils-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/hroptatyr/dateutils/downloads/${name}.tar.xz";
    sha256 = "0y2jsmvilljbid14lzmk3kgvasn4h7hr6y3wwbr3lkgwfn4y9k3c";
  };

  meta = with stdenv.lib; {
    description = "A bunch of tools that revolve around fiddling with dates and times in the command line";
    homepage = http://www.fresse.org/dateutils/;
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.paperdigits ];
  };
}
