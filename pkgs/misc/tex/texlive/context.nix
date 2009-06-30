args: with args;
rec {
  name = "context-2008.01.28";
  src = fetchurl {
    url = http://ftp.de.debian.org/debian/pool/main/c/context/context_2008.01.28.orig.tar.gz;
    sha256 = "0infkn73v3kwqgg6b7rqnr28i5z5dbdfapy6ppzlcnr19yj4nh9y";
  };

  buildInputs = [texLive];
  phaseNames = ["doCopy"];
  doCopy = fullDepEntry (''
    ensureDir $out/share/texmf
    cp -r * $out/share/texmf
  '') ["minInit" "doUnpack" "defEnsureDir" "addInputs"];

  meta = {
    description = "ConTEXt TeX wrapper";
  };

}
 
