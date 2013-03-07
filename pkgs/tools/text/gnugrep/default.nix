{ stdenv, fetchurl, pcre, libiconv ? null }:

let version = "2.14"; in

stdenv.mkDerivation {
  name = "gnugrep-${version}";

  src = fetchurl {
    url = "mirror://gnu/grep/grep-${version}.tar.xz";
    sha256 = "1qbjb1l7f9blckc5pqy8jlf6482hpx4awn2acmhyf5mv9wfq03p7";
  };

  buildInputs = [ pcre ]
    ++ stdenv.lib.optional (libiconv != null) libiconv;

  NIX_LDFLAGS = stdenv.lib.optionalString (libiconv != null) "-L${libiconv}/lib -liconv";

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

    license = "GPLv3+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.all;
  };

  passthru = {inherit pcre;};
}
