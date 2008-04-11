args : with args; 
rec {
  src = fetchurl {
    url = http://ftp.de.debian.org/debian/pool/main/u/uucp/uucp_1.07.orig.tar.gz;
    sha256 = "0b5nhl9vvif1w3wdipjsk8ckw49jj1w85xw1mmqi3zbcpazia306";
  };

  buildInputs = [];
  configureFlags = [];

  /* doConfigure should be specified separately */
  phaseNames = ["doConfigure" "doMakeInstall"];
      
  name = "uucp-" + version;
  meta = {
    description = "Unix-unix cp over serial line, also includes cu program";
  };
}
