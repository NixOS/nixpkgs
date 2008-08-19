args : with args; with builderDefs;
        let localDefs = builderDefs.meta.function ((rec {
                src = /* put a fetchurl here */
                fetchurl {
                        url = ftp://ftp.dict.org/pub/dict/dictd-1.9.15.tar.gz;
                        sha256 = "0p41yf72l0igmshz6vxy3hm51z25600vrnb9j2jpgws4c03fqnac";
                };

                buildInputs = [flex bison which];
                configureFlags = [ " --datadir=/var/run/current-system/share/dictd " ];
        }) // args);
        in with localDefs;
stdenv.mkDerivation rec {
        name = "dict-"+version;
        builder = writeScript (name + "-builder")
                (textClosure localDefs 
                        [doConfigure doMakeInstall doForceShare doPropagate]);
        meta = {
                description = "
                Dict protocol server and client.
";
                inherit src;
        };
}
