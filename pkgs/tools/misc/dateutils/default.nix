{ lib, stdenv, fetchurl, autoreconfHook, tzdata, fetchpatch }:

stdenv.mkDerivation rec {
  version = "0.4.9";
  pname = "dateutils";

  src = fetchurl {
    url = "https://bitbucket.org/hroptatyr/dateutils/downloads/${pname}-${version}.tar.xz";
    sha256 = "1hy96h9imxdbg9y7305mgv4grr6x4qic9xy3vhgh15lvjkcmc0kr";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ tzdata ]; # needed for datezone
  enableParallelBuilding = true;

  doCheck = true;

  meta = with lib; {
    description = "A bunch of tools that revolve around fiddling with dates and times in the command line";
    homepage = "http://www.fresse.org/dateutils/";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.paperdigits ];
  };
}
