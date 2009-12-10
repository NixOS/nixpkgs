{stdenv, fetchurl, pcre}:

let version = "2.5.4"; in

stdenv.mkDerivation {
  name = "gnugrep-${version}";
  
  src = fetchurl {
    url = "mirror://gnu/grep/grep-${version}.tar.bz2";
    sha256 = "0800lj1ywf43x5jnjyga56araak0f601sd9k5q1vv3s5057cdgha";
  };
  
  buildInputs = [pcre];

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
  };

  passthru = {inherit pcre;};
}
