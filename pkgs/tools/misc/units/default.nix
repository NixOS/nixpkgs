{ stdenv, fetchurl, readline }:

stdenv.mkDerivation rec {
  name = "units-${version}";
  version = "2.14";

  src = fetchurl {
    url = "mirror://gnu/units/${name}.tar.gz";
    sha256 = "9d33893d82f3ddd831d5822992007c40bcd0826ae67d3cbc96539951fb0a82e8";
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
