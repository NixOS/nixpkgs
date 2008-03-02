args : with args; with builderDefs {src="";} null;
let localDefs = builderDefs (rec {
    src = /* put a fetchurl here */
    fetchurl {
      url = ftp://ftp.deepspace6.net/pub/ds6/sources/nc6/nc6-1.0.tar.bz2;
      sha256 = "01l28zv1yal58ilfnz6albdzqqxzsx3a58vmc14r9gv0bahffdgb";
    };

    buildInputs = [];
    configureFlags = [];
    }) null; /* null is a terminator for sumArgs */
in with localDefs;
stdenv.mkDerivation rec {
  name = "nc6-"+version;
  builder = writeScript (name + "-builder")
    (textClosure localDefs 
     [doConfigure doMakeInstall doForceShare doPropagate]);
  meta = {
    description = "
      nc6 - one more netcat, IPv6 support included.
    ";
    homepage = "http://www.deepspace6.net/projects/netcat6.html";
    inherit src;
  };
}

