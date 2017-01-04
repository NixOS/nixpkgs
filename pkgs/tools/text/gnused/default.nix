{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "gnused-4.3";

  src = fetchurl {
    url = mirror://gnu/sed/sed-4.2.2.tar.bz2;
    sha256 = "1myvrmh99jsvk7v3d7crm0gcrq51hmmm1r2kjyyci152in1x2j7h";
  };

  outputs = [ "out" "info" ];

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

    license = stdenv.lib.licenses.gpl3Plus;

    platforms = stdenv.lib.platforms.all;
    maintainers = [ ];
  };
}
