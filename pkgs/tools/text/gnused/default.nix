{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "gnused-4.2.2";

  src = fetchurl {
    url = mirror://gnu/sed/sed-4.2.2.tar.gz;
    sha256 = "f048d1838da284c8bc9753e4506b85a1e0cc1ea8999d36f6995bcb9460cddbd7";
  };

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

    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
