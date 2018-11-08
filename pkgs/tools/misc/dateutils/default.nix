{ stdenv, fetchurl, autoreconfHook, tzdata }:

stdenv.mkDerivation rec {
  version = "0.4.5";
  name = "dateutils-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/hroptatyr/dateutils/downloads/${name}.tar.xz";
    sha256 = "1pnbc186mnvmyb5rndm0ym50sjihsy6m6crz62xxsjbxggza1mhn";
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
