args : with args; 
rec {
  src = /* Here a fetchurl expression goes */
  fetchurl {
    url = http://www.dest-unreach.org/socat/download/socat-1.6.0.1.tar.bz2;
    sha256 = "1cl7kf0rnbvjxz8vdkmdh1crd069qmz1jjw40r8bydgpn0nsh6qd";
  };

  buildInputs = [openssl];
  configureFlags = [];

  /* doConfigure should be specified separately */
  phaseNames = ["doPatch" "doConfigure" "doMakeInstall"];
      
  name = "socat-" + version;
  meta = {
    description = "Socat - a different replacement for netcat";
    longDesc = "
        Socat, one more analogue of netcat, but not mimicking it.
	'netcat++' (extended design, new implementation)
";
        homepage = "http://www.dest-unreach.org/socat/";
	srcs = patches;
  };
}
