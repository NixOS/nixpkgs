{ stdenv, fetchurl, readline }:

stdenv.mkDerivation rec {
  name = "units-${version}";
  version = "2.13";

  src = fetchurl {
    url = "mirror://gnu/units/${name}.tar.gz";
    sha256 = "1awhjw9zjlfb8s5g3yyx63f7ddfcr1sanlbxpqifmrgq24ql198b";
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
