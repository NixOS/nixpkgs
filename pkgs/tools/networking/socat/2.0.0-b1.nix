args : with args; with builderDefs {src="";} null;
    let localDefs = builderDefs (rec {
        src = /* put a fetchurl here */
        fetchurl {
            url = http://www.dest-unreach.org/socat/download/socat-2.0.0-b1.tar.bz2;
            sha256 = "0ybd5fw22icl10r33k987rskh9gvysm1jph90a1pfdjj57cy44fk";
        };
        
        buildInputs = [openssl];
        configureFlags = [];
    }) null; /* null is a terminator for sumArgs */
    in with localDefs;
stdenv.mkDerivation rec {
    name = "socat-"+version;
    builder = writeScript (name + "-builder")
        (textClosure localDefs 
            [doPatch doConfigure doMakeInstall doForceShare doPropagate]);
    meta = {
        description = "
        Socat, one more analogue of netcat, but not mimicking it.
	'netcat++' (extended design, new implementation)
";
        homepage = "http://www.dest-unreach.org/socat/";
        inherit src;
    };
}
