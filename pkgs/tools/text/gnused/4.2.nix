{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "gnused-4.2.1";
  
  src = fetchurl {
    url = "mirror://gnu/sed/sed-4.2.1.tar.bz2";
    sha256 = "13wlsb4sf5d5a82xjhxqmdvrrn36rmw5f0pl9qyb9zkvldnb7hra";
  };
  
  doCheck = true;

  meta = {
    homepage = http://www.gnu.org/software/sed/;
    description = "GNU sed, a batch stream editor";

    longDescription = ''
      Sed (stream editor) isn't really a true text editor or text
      processor.  Instead, it is used to filter text, i.e., it takes
      text input and performs some operation (or set of operations) on
      it and outputs the modified text.  Sed is typically used for
      extracting part of a file using pattern matching or substituting
      multiple occurrences of a string within a file.
    '';

    license = "GPLv3+";
  };
}
