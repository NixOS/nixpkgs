{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "0.4.4";
  name = "dateutils-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/hroptatyr/dateutils/downloads/${name}.tar.xz";
    sha256 = "0ky8177is4swgxfqczc78d7yjc13w626k515qw517086n7xjxk59";
  };

  meta = with stdenv.lib; {
    description = "A bunch of tools that revolve around fiddling with dates and times in the command line";
    homepage = http://www.fresse.org/dateutils/;
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.paperdigits ];
  };
}
