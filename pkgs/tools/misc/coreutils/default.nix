{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "coreutils-6.10";
  
  src = fetchurl {
    url = mirror://gnu/coreutils/coreutils-6.10.tar.gz;
    sha256 = "0zpbxfl16sq45s53fxw43i9i8lrdcc845714c1j5f84zi13ka08x";
  };

  meta = {
    homepage = http://www.gnu.org/software/coreutils/;
    description = "The basic file, shell and text manipulation utilities of the GNU operating system";
  };
}
