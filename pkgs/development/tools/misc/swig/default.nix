{ perlSupport, pythonSupport
, stdenv, fetchurl, perl ? null, python ? null}:

assert perlSupport -> perl != null;
assert pythonSupport -> python != null;

stdenv.mkDerivation {
  name = "swig-1.3.19";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/swig/swig-1.3.19.tar.gz;
    md5 = "a733455544426b31868dd87fc162e750";
  };

  perlSupport = perlSupport;
  pythonSupport = pythonSupport;

  perl = if perlSupport then perl else null;
  python = if pythonSupport then python else null;
}