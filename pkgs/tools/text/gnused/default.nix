{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "gnused-4.1.5";
  
  src = fetchurl {
    url = mirror://gnu/sed/sed-4.1.5.tar.gz;
    md5 = "7a1cbbbb3341287308e140bd4834c3ba";
  };
  
  # !!! hack: this should go away in gnused > 4.1.5
  patches = [./gettext-fix.patch];

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

    license = "GPLv2+";
  };
}
