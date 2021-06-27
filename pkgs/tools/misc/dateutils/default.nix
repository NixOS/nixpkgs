{ lib, stdenv, fetchurl, autoreconfHook, tzdata, fetchpatch }:

stdenv.mkDerivation rec {
  version = "0.4.8";
  pname = "dateutils";

  src = fetchurl {
    url = "https://bitbucket.org/hroptatyr/dateutils/downloads/${pname}-${version}.tar.xz";
    sha256 = "0061f36axskm7yq9cp64x5a5phil8d3zgcd668nfmqzk9ji58w1z";
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
