{ stdenv, fetchurl, readline }:

stdenv.mkDerivation rec {
  name = "units-${version}";
  version = "2.16";

  src = fetchurl {
    url = "mirror://gnu/units/${name}.tar.gz";
    sha256 = "11hnp3gcmcc5kci2caxw4hs6m08h2mhqs3xzqq7iafx1ha2ggwyw";
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
