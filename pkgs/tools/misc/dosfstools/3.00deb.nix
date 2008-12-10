args : with args; with builderDefs;
    let patch = 
        fetchurl {
          url = http://ftp.de.debian.org/debian/pool/main/d/dosfstools/dosfstools_3.0.0-1.diff.gz;
          sha256 = "5ecab7e9cf213b0cc7406649ca59edb9ec6daad2fa454bce423ccb1744fc1336";
         };
       localDefs = builderDefs.passthru.function (rec {
         src = /* put a fetchurl here */
           fetchurl {
            url = http://ftp.de.debian.org/debian/pool/main/d/dosfstools/dosfstools_3.0.0.orig.tar.gz;
            sha256 = "46125aafff40e8215e6aa30087c6c72a82654c8f5fca4878adc1fa26342eab58";
           };
	preBuild = FullDepEntry (''
	  gunzip < ${patch} | patch -Np1
	'')["minInit" "doUnpack"];

        buildInputs = [];
        configureFlags = [];
	makeFlags = " PREFIX=$out ";
    });
    in with localDefs;
stdenv.mkDerivation rec {
    name = "dosfstools-"+version;
    builder = writeScript (name + "-builder")
        (textClosure localDefs 
            [preBuild "doMakeInstall" doForceShare doPropagate]);
    meta = {
        description = "
        Dosfstools - utilities for vfat file system.
";
	homepage = "http://sixpak.org/dosfstools/dosfstools-2.8vb2.tar.gz";
        inherit src;
    };
}
