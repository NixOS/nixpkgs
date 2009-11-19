{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "ddrescue-1.8";
  
  src = fetchurl {
    url = "http://ftp.gnu.org/gnu/ddrescue/${name}.tar.bz2";
    sha256 = "080k1s4knh9baw3dxr5vqjjph6dqzkfpk0kpld0a3qc07vsxmhbz";
  };

  meta = {
    description = "GNU ddrescue - advanced dd for corrupted media";
  };
}
  
