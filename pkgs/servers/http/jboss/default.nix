{ stdenv, fetchurl, jdk5, jdk }:

stdenv.mkDerivation {
  name = "jboss-4.2.2.GA";

  builder = ./builder.sh;
  src = 
    fetchurl {
      url = http://garr.dl.sourceforge.net/sourceforge/jboss/jboss-4.2.2.GA-src.tar.gz;
      md5 = "2a626cdccabe712628555676d67ad44a";
    };

  inherit jdk5 jdk;

  meta = {
    homepage = "http://www.jboss.org/";
    description = "JBoss, Open Source J2EE application server";
    license = "GPL/LGPL";
  };
}
