{ fetchurl, lib, stdenv, autogen }:

stdenv.mkDerivation rec {
  pname = "complexity";
  version = "1.10";

  src = fetchurl {
    url = "mirror://gnu/complexity/${pname}-${version}.tar.gz";
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

    license = lib.licenses.gpl3Plus;

    homepage = "https://www.gnu.org/software/complexity/";

    platforms = lib.platforms.gnu ++ lib.platforms.linux;
    maintainers = [ ];
  };
}
