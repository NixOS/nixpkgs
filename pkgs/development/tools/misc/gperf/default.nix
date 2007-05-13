{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "gperf-3.0.3";
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/gperf/gperf-3.0.3.tar.gz;
    sha256 = "0mchz9rawhm9sb6rvm05vdlxajs9ycv4907h3j07xqnrr0kpaa33";
  };
}
