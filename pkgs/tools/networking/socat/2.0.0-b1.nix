args : with args; 
rec {
  src = /* Here a fetchurl expression goes */
        fetchurl {
            url = http://www.dest-unreach.org/socat/download/socat-2.0.0-b1.tar.bz2;
            sha256 = "0ybd5fw22icl10r33k987rskh9gvysm1jph90a1pfdjj57cy44fk";
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
