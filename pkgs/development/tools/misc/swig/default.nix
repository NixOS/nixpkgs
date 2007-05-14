{ perlSupport, pythonSupport, javaSupport
, stdenv, fetchurl, perl ? null, python ? null, jdk ? null}:

assert perlSupport -> perl != null;
assert pythonSupport -> python != null;
assert javaSupport -> jdk != null;

stdenv.mkDerivation {
  name = "swig-1.3.31";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://surfnet.dl.sourceforge.net/sourceforge/swig/swig-1.3.31.tar.gz;
    sha256 = "01fqf6xvhaqh76kh13bknn5j7axpm1pdnjpzwxsa9d1lbq4n7bf2";
  };

  inherit perlSupport pythonSupport javaSupport;

  perl = if perlSupport then perl else null;
  python = if pythonSupport then python else null;
  jdk = if javaSupport then jdk else null;
}
