{ perlSupport, pythonSupport, javaSupport
, stdenv, fetchurl, perl ? null, python ? null, jdk ? null}:

assert perlSupport -> perl != null;
assert pythonSupport -> python != null;
assert javaSupport -> jdk != null;

stdenv.mkDerivation {
  name = "swig-1.3.29";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://surfnet.dl.sourceforge.net/sourceforge/swig/swig-1.3.29.tar.gz;
    md5 = "44c6f6d8d724cf7fa4a5109e6f63c9b1";
  };

  inherit perlSupport pythonSupport javaSupport;

  perl = if perlSupport then perl else null;
  python = if pythonSupport then python else null;
  jdk = if javaSupport then jdk else null;
}
