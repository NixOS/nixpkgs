{ stdenv, fetchurl, pcre, libiconvOrNull }:

let version = "2.20"; in

stdenv.mkDerivation {
  name = "gnugrep-${version}";

  src = fetchurl {
    url = "mirror://gnu/grep/grep-${version}.tar.xz";
    sha256 = "0rcs0spsxdmh6yz8y4frkqp6f5iw19mdbdl9s2v6956hq0mlbbzh";
  };

  buildInputs = [ pcre libiconvOrNull ];

  NIX_LDFLAGS = stdenv.lib.optionalString (libiconvOrNull != null) "-L${libiconvOrNull}/lib -liconv";

  doCheck = !stdenv.isDarwin;

  # On Mac OS X, force use of mkdir -p, since Grep's fallback
  # (./install-sh) is broken.
  preConfigure = ''
    export MKDIR_P="mkdir -p"
  '';

  meta = {
    homepage = http://www.gnu.org/software/grep/;
    description = "GNU implementation of the Unix grep command";

    longDescription = ''
      The grep command searches one or more input files for lines
      containing a match to a specified pattern.  By default, grep
      prints the matching lines.
    '';

    license = stdenv.lib.licenses.gpl3Plus;

    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.all;
  };

  passthru = {inherit pcre;};
}
