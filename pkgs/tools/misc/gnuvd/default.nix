{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "gnuvd-1.0.12";

  src = fetchurl {
    url = http://www.djcbsoftware.nl/code/gnuvd/gnuvd-1.0.12.tar.gz ;
    sha256 = "0mpy76a0pxy62zjiihlzmvl4752hiwxhfs8rm1v5zgdr78acxyxz";
  };

  meta = {
    description = "Command-line dutch dictionary application";
    homepage = http://www.djcbsoftware.nl/code/gnuvd/;
  };
}
