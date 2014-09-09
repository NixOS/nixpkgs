{ stdenv, fetchurl, pkgconfig }:

stdenv.mkDerivation rec {

  name = "mlmmj-${version}";
  version = "1.2.18.1";

  src = fetchurl {
    url = "http://mlmmj.org/releases/${name}.tar.gz";
    sha256 = "336b6b20a6d7f0dcdc7445ecea0fe4bdacee241f624fcc710b4341780f35e383";
  };

  meta = with stdenv.lib; {
    homepage = http://mlmmj.org;
    description = "Mailing List Management Made Joyful";
    maintainers = [ maintainers.edwtjo ];
    platforms = platforms.linux;
    license = licenses.mit;
  };

}