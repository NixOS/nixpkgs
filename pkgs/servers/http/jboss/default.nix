{ stdenv, fetchurl, unzip, jdk, lib }:

stdenv.mkDerivation {
  name = "jboss-5.1.0.GA";
  src = fetchurl {
    url = mirror://sourceforge/jboss/jboss-5.1.0.GA-jdk6.zip;
    sha256 = "0wy5666h554x1qq4w0rzg3krp4rqrijq0ql7dkx6qgl3vpj9xr5y";
  };

  buildInputs = [ unzip ];
      
  buildPhase = ''
    sed -i -e "/GREP/aJAVA_HOME=${jdk}" bin/run.sh
  '';
  
  installPhase = ''
    mkdir -p $out
    cp -av * $out
  '';
  
  meta = {
    homepage = "http://www.jboss.org/";
    description = "JBoss, Open Source J2EE application server";
    license = "GPL/LGPL";
    maintainers = [ lib.maintainers.sander ];
  };
}
