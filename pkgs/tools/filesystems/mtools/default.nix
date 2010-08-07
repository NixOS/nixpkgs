{ stdenv, fetchurl, texinfo }:

stdenv.mkDerivation rec {
  name = "mtools-4.0.13";

  src = fetchurl {
    url = "mirror://gnu/mtools/${name}.tar.bz2";
    sha256 = "1nj7lc2q1g66l3ma8z1c95nglf9himnr6k85b5rry99f9za7npbg";
  };

  buildInputs = [ texinfo ];

  meta = {
    homepage = http://www.gnu.org/software/mtools/;
    description = "Utilities to access MS-DOS disks without mounting them";
  };
}
