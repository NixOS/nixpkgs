args : with args; 
let 
  version = "2.0.0-b3"; 
  patches = [];
in
rec {
  src = /* Here a fetchurl expression goes */
        fetchurl {
            url = http://www.dest-unreach.org/socat/download/socat-2.0.0-b3.tar.bz2;
            sha256 = "0p4v8m898dzcardsw02xdda3y3b1rky7v956rm27x43783w5qmsx";
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
