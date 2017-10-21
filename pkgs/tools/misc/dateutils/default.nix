{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "0.4.2";
  name = "dateutils-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/hroptatyr/dateutils/downloads/${name}.tar.xz";
    sha256 = "0sxl5rz9rw02dfn5mdww378hjgnnbxavs52viyfyx620b29finpc";
  };

  meta = with stdenv.lib; {
    description = "A bunch of tools that revolve around fiddling with dates and times in the command line";
    homepage = http://www.fresse.org/dateutils/;
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.paperdigits ];
  };
}
