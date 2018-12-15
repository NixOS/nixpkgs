{ stdenv, fetchurl, readline }:

stdenv.mkDerivation rec {
  name = "units-${version}";
  version = "2.18";

  src = fetchurl {
    url = "mirror://gnu/units/${name}.tar.gz";
    sha256 = "0y26kj349i048y4z3xrk90bvciw2j6ds3rka7r7yn3183hirr5b4";
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
