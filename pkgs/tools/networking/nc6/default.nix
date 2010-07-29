args : with args; with builderDefs;
let localDefs = builderDefs.passthru.function (rec {
    src = /* put a fetchurl here */
    fetchurl {
      url = ftp://ftp.deepspace6.net/pub/ds6/sources/nc6/nc6-1.0.tar.bz2;
      sha256 = "01l28zv1yal58ilfnz6albdzqqxzsx3a58vmc14r9gv0bahffdgb";
    };

    buildInputs = [];
    configureFlags = [];
    });
in with localDefs;
stdenv.mkDerivation rec {
  name = "nc6-1.0";
  builder = writeScript (name + "-builder")
    (textClosure localDefs 
     [doConfigure doMakeInstall doForceShare doPropagate]);
  meta = {
    description = "A netcat implementation with IPv6 support";
    homepage = "http://www.deepspace6.net/projects/netcat6.html";
    inherit src;
  };
}

