args : with args; with builderDefs;
    let patch = 
        fetchurl {
          url = http://ftp.de.debian.org/debian/pool/main/d/dosfstools/dosfstools_2.11-2.3.diff.gz;
          sha256 = "0bzjhpgg4ih6c76ax8byis9vxgkr2c7bbbshqrkfq8j7ar48n5ld";
        };	
      localDefs = builderDefs.passthru.function (rec {
        src = /* put a fetchurl here */
          fetchurl {
            url = http://ftp.de.debian.org/debian/pool/main/d/dosfstools/dosfstools_2.11.orig.tar.gz;
            sha256 = "1154k0y04npblgac81p4pcmglilk1ldrqll4hvbrwgcb7096vb0f";
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
