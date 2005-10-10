{stdenv, fetchurl, flex}:

stdenv.mkDerivation {
  name = "bc-1.0.6";
  src = fetchurl {
    url = http://ftp.gnu.org/pub/gnu/bc/bc-1.06.tar.gz;
    md5 = "d44b5dddebd8a7a7309aea6c36fda117";
  };

  buildInputs = [flex];
}
