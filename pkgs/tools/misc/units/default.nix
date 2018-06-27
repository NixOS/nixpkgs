{ stdenv, fetchurl, readline }:

stdenv.mkDerivation rec {
  name = "units-${version}";
  version = "2.17";

  src = fetchurl {
    url = "mirror://gnu/units/${name}.tar.gz";
    sha256 = "1n2xzpnxfn475zkd8rzs5gg58xszjbr4bdbgvk6hryzimvwwj0qz";
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
