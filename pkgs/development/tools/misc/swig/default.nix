{ perlSupport, pythonSupport, javaSupport
, stdenv, fetchurl, perl ? null, python ? null, j2sdk ? null}:

assert perlSupport -> perl != null;
assert pythonSupport -> python != null;
assert javaSupport -> j2sdk != null;

stdenv.mkDerivation {
  name = "swig-1.3.22";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/swig/swig-1.3.22.tar.gz;
    md5 = "501121a2ddb61155348dfbc7c87286ba";
  };

  inherit perlSupport pythonSupport javaSupport;

  perl = if perlSupport then perl else null;
  python = if pythonSupport then python else null;
  j2sdk = if javaSupport then j2sdk else null;
}