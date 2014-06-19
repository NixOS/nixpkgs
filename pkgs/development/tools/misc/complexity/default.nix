{ fetchurl, stdenv, autogen, texinfo }:

stdenv.mkDerivation rec {
  # FIXME: Currently fails to build.
  name = "complexity-0.4";

  src = fetchurl {
    url = "mirror://gnu/complexity/${name}.tar.gz";
    sha256 = "0dmk2pm7vi95482hnbbp597640bsjw5gg57j8cpy87855cl69yr8";
  };

  buildInputs =
    [ autogen
      texinfo  # XXX: shouldn't be needed, per GCS
    ];

  # Hack to work around build defect.
  makeFlags = "MAKEINFOFLAGS=--no-validate";

  doCheck = true;

  preBuild = ''
    sed -i -e '/gets is a security/d' lib/stdio.in.h
    sed -i '42 i\
      #undef false\
      #undef true' src/complexity.h
  '';

  meta = {
    description = "GNU Complexity, C code complexity measurement tool";

    longDescription =
      '' GNU Complexity is a tool designed for analyzing the complexity of C
         program functions.  It is very similar to the McCabe scoring, but
         addresses several issues not considered in that scoring scheme.
      '';

    license = stdenv.lib.licenses.gpl3Plus;

    homepage = http://www.gnu.org/software/complexity/;

    platforms = stdenv.lib.platforms.gnu;
    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
