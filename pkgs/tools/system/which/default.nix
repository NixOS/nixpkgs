{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "which-2.20";
  
  src = fetchurl {
    url = mirror://gnu/which/which-2.20.tar.gz;
    sha256 = "1y2p50zadb36izzh2zw4dm5hvdiydqf3qa88l8kav20dcmfbc5yl";
  };

  meta = {
    homepage = http://ftp.gnu.org/gnu/which/;
  };
}
