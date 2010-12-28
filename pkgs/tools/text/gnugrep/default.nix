{ stdenv, fetchurl, pcre, libiconv ? null}:

let version = "2.7"; in

stdenv.mkDerivation ({
  name = "gnugrep-${version}";

  src = fetchurl {
    url = "mirror://gnu/grep/grep-${version}.tar.gz";
    sha256 = "1b8vksfd1ngharac3ygaqim3lrf0yqap992sg0vfm7572l88655d";
  };

  buildInputs = [ pcre ]
    ++ (stdenv.lib.optional (libiconv != null) libiconv);

  doCheck = if stdenv.isDarwin then false else true;

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
} // (if libiconv != null then { NIX_LDFLAGS="-L${libiconv}/lib -liconv"; } else {}) )
