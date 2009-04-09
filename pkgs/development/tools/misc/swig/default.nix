{ perlSupport, pythonSupport, javaSupport
, stdenv, fetchurl, perl ? null, python ? null, jdk ? null}:

assert perlSupport -> perl != null;
assert pythonSupport -> python != null;
assert javaSupport -> jdk != null;

stdenv.mkDerivation {
  name = "swig-1.3.39";

  builder = ./builder.sh;
  src = fetchurl {
    url = mirror://sourceforge/swig/swig-1.3.39.tar.gz;
    sha256 = "1p0i5c52y8d7wvn5h3qf62q5ic7kgbj2vc5dm8zy07ygff9msbdv";
  };

  inherit perlSupport pythonSupport javaSupport;

  perl = if perlSupport then perl else null;
  python = if pythonSupport then python else null;
  jdk = if javaSupport then jdk else null;
}
