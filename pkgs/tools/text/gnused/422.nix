{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "gnused-4.2.2";

  src = fetchurl {
    url = mirror://gnu/sed/sed-4.2.2.tar.bz2;
    sha256 = "f048d1838da284c8bc9753e4506b85a1e0cc1ea8999d36f6995bcb9460cddbd7";
  };

  configureFlags = stdenv.lib.optional stdenv.hostPlatform.isMinGW "ac_cv_func__set_invalid_parameter_handler=no";

  outputs = [ "out" "info" ];

  meta = {
    homepage = https://www.gnu.org/software/sed/;
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
