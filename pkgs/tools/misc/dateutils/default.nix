{ stdenv, fetchurl, autoreconfHook, tzdata }:

stdenv.mkDerivation rec {
  version = "0.4.6";
  pname = "dateutils";

  src = fetchurl {
    url = "https://bitbucket.org/hroptatyr/dateutils/downloads/${pname}-${version}.tar.xz";
    sha256 = "1kaphw474lz7336awr9rzsgcsr1p9njsjsryd8i0ywg5g8qp3816";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ tzdata ]; # needed for datezone
  enableParallelBuilding = true;

  doCheck = true;

  meta = with stdenv.lib; {
    description = "A bunch of tools that revolve around fiddling with dates and times in the command line";
    homepage = http://www.fresse.org/dateutils/;
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.paperdigits ];
  };
}
