{ perlSupport, pythonSupport, javaSupport
, stdenv, fetchurl, perl ? null, python ? null, jdk ? null}:

assert perlSupport -> perl != null;
assert pythonSupport -> python != null;
assert javaSupport -> jdk != null;

stdenv.mkDerivation {
  name = "swig-1.3.33";

  builder = ./builder.sh;
  src = fetchurl {
    url = mirror://sourceforge/swig/swig-1.3.33.tar.gz;
    sha256 = "02rz31i642sbsngny7k98d9hxlkcb9snvbzlnz3sh0qiyr3ciggv";
  };

  inherit perlSupport pythonSupport javaSupport;

  perl = if perlSupport then perl else null;
  python = if pythonSupport then python else null;
  jdk = if javaSupport then jdk else null;
}
