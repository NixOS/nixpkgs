{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "gnused-${version}";
  version = "4.4";

  src = fetchurl {
    url = "mirror://gnu/sed/sed-${version}.tar.xz";
    sha256 = "0fv88bcnraixc8jvpacvxshi30p5x9m7yb8ns1hfv07hmb2ypmnb";
  };

  outputs = [ "out" "info" ];

  nativeBuildInputs = [ perl ];
  preConfigure = "patchShebangs ./build-aux/help2man";

  crossAttrs = {
    # The tarball ships with a fine prebuilt manpage, but the make rules try to rebuild it,
    # which won't work when cross compiling as help2man needs to execute the binaries.
    postConfigure = ''
      sed -i Makefile -e 's|doc/sed\.1:|dummy:|'
    '';
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

    license = stdenv.lib.licenses.gpl3Plus;

    platforms = stdenv.lib.platforms.all;
    maintainers = [ ];
  };
}
