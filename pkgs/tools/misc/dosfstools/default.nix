args : with args; with builderDefs;
       let localDefs = builderDefs.passthru.function (rec {
         src = /* put a fetchurl here */
           fetchurl {
            url = http://www.daniel-baumann.ch/software/dosfstools/dosfstools-3.0.1.tar.bz2;
            sha256 = "7fab0de42391277028071d01ff4da83ff9a399408ccf29958cdee62ffe746d45";
           };

        buildInputs = [];
        configureFlags = [];
        makeFlags = " PREFIX=$out ";
    });
    in with localDefs;
stdenv.mkDerivation rec {
    name = "dosfstools-3.01";
    builder = writeScript (name + "-builder")
        (textClosure localDefs 
            ["doMakeInstall" doForceShare doPropagate]);
    meta = {
        description = "Dosfstools - utilities for vfat file system.";
	homepage = "http://www.daniel-baumann.ch/software/dosfstools/";
        inherit src;
    };
}
