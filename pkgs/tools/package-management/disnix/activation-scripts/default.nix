{ stdenv, fetchurl
, ejabberd ? null, mysql ? null
, enableApacheWebApplication ? false
, enableAxis2WebService ? false
, enableEjabberdDump ? false
, enableMySQLDatabase ? false
, enableTomcatWebApplication ? false
, catalinaBaseDir ? "/var/tomcat"
}:

assert enableMySQLDatabase -> mysql != null;
assert enableEjabberdDump -> ejabberd != null;

stdenv.mkDerivation {
  name = "disnix-activation-scripts-0.2pre24557";
  src = fetchurl {
    url = http://hydra.nixos.org/build/727573/download/1/disnix-activation-scripts-0.2pre24557.tar.gz;
    sha256 = "089bp700rjdxfa0wzf81420i5iphs78kkz41506ibsfnbm8k3axj";
  };
  
  preConfigure = if enableEjabberdDump then "export PATH=$PATH:${ejabberd}/sbin" else "";
  
  configureFlags = ''
                     ${if enableApacheWebApplication then "--with-apache" else "--without-apache"}
		     ${if enableAxis2WebService then "--with-axis2" else "--without-axis2"}
		     ${if enableEjabberdDump then "--with-ejabberd" else "--without-ejabberd"}
		     ${if enableMySQLDatabase then "--with-mysql" else "--without-mysql"}
		     ${if enableTomcatWebApplication then "--with-tomcat=${catalinaBaseDir}" else "--without-tomcat"}
		   '';
		   
  buildInputs = []
                ++ stdenv.lib.optional enableEjabberdDump ejabberd
                ++ stdenv.lib.optional enableMySQLDatabase mysql;
}
