{ stdenv, fetchurl, which, screen }:

let
  name = "wdiff-1.0.0";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://gnu/wdiff/${name}.tar.gz";
    sha256 = "00p0yww8dfszzhbwkfl4v5l9r55v9qznx3p089l2m2drjb1ahp3v";
  };

  # Required for the compile-time for the test suite.
  buildInputs = [ which screen ];

  doCheck = true;

  meta = {
    homepage = http://www.gnu.org/software/wdiff/;
    description = "GNU wdiff, comparing files on a word by word basis";
    license = "GPLv3+";
    maintainers = [ stdenv.lib.maintainers.eelco stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.all;
  };
}
