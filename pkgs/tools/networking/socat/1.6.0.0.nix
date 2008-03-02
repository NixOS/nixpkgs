args : with args; with builderDefs {src="";} null;
    let localDefs = builderDefs (rec {
        src = /* put a fetchurl here */
        fetchurl {
            url = http://www.dest-unreach.org/socat/download/socat-1.6.0.0.tar.bz2;
            sha256 = "1j01iazwfr63q71cfcfzrdz8digqlg3ldhlbb72yl5mn9awr0w0m";
        };
        patches = [
          (fetchurl {
              url = http://www.dest-unreach.org/socat/contrib/socat-servicenames.patch;
              sha256 = "1r8zd6mk257n01i34i5syxl2k6fr35nlr7bqs9sfc79irjl62z66";
          })
          (fetchurl {
              url = http://www.dest-unreach.org/socat/contrib/socat-maxfds.patch.gz;
              sha256 = "0fsn0k0qsrdbjbhj09a6kxfsxb7yhxs4cad26znd9naginsj7pxa";
          })
        ];
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
