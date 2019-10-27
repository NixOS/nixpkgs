{ stdenv, fetchurl, readline }:

stdenv.mkDerivation rec {
  pname = "units";
  version = "2.19";

  src = fetchurl {
    url = "mirror://gnu/units/${pname}-${version}.tar.gz";
    sha256 = "0mk562g7dnidjgfgvkxxpvlba66fh1ykmfd9ylzvcln1vxmi6qj2";
  };

  buildInputs = [ readline ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Unit conversion tool";
    homepage = https://www.gnu.org/software/units/;
    license = [ licenses.gpl3Plus ];
    platforms = platforms.all;
    maintainers = [ maintainers.vrthra ];
  };
}
