{ fetchurl, stdenv, autogen }:

stdenv.mkDerivation rec {
  name = "complexity-${version}";
  version = "1.10";

  src = fetchurl {
    url = "mirror://gnu/complexity/${name}.tar.gz";
    sha256 = "1vfns9xm7w0wrz12a3w15slrqnrfh6qxk15nv7qkj3irll3ff522";
  };

  buildInputs = [ autogen ];

  doCheck = true;

  meta = {
    description = "C code complexity measurement tool";

    longDescription =
      '' GNU Complexity is a tool designed for analyzing the complexity of C
         program functions.  It is very similar to the McCabe scoring, but
         addresses several issues not considered in that scoring scheme.
      '';

    license = stdenv.lib.licenses.gpl3Plus;

    homepage = https://www.gnu.org/software/complexity/;

    platforms = stdenv.lib.platforms.gnu ++ stdenv.lib.platforms.linux;
    maintainers = [ ];
  };
}
