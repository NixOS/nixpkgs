x@{builderDefsPackage
  , unzip
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="jena-joseki";
    version="3.4.3-201103";
    name="${baseName}-${version}";
  };
in
rec {
  inherit (sourceInfo) name version;
  inherit buildInputs;

  tarballs = {
    jenaBin = a.fetchurl {
      url = "mirror://sourceforge/project/jena/Jena/Jena-2.6.4/jena-2.6.4.zip";
      sha256 = "ec23a24eee9148b1ddb366ab035a48eacd43c2b50c534a7bdd9cf31c6f8a9e7c";
    };
    josekiBin = a.fetchurl {
      url = "mirror://sourceforge/project/joseki/Joseki-SPARQL/Joseki-3.4.3/joseki-3.4.3.zip";
      sha256 = "cde1138e7bafcc2db7800dcde08f268237accd76c0a3e4b4c95cc96eacdcad12";
    };
    tdbBin = a.fetchurl {
      url = "mirror://sourceforge/project/jena/TDB/TDB-0.8.9/tdb-0.8.9.zip";
      sha256 = "78fd4b6cea5a6e412f1d58ba8a9e1fc72315becdf06f3675e4e604cd4435779e";
    };
    arqBin = a.fetchurl {
      url = "mirror://sourceforge/project/jena/ARQ/ARQ-2.8.7/arq-2.8.7.zip";
      sha256 = "66990e92514a85a9596a7efaf128041002cd098e063964dd5d2264cfcdd26070";
    };
    jettyBin = a.fetchurl {
      url = "http://dist.codehaus.org/jetty/jetty-6.1.26/jetty-6.1.26.zip";
      sha256 = "96c08eb87ec3772dccc2b3dba54fea85ccc3f804faf7429eecfba3ed55648187";
    };
  };
  tarballFiles = map (x: builtins.getAttr x tarballs) (builtins.attrNames tarballs);

  /* doConfigure should be removed if not needed */
  phaseNames = ["doDeploy" "fixScripts"];

  fixScripts = a.doPatchShebangs ''$TARGET/bin'';
      
  doDeploy = a.fullDepEntry (''
    ${a.lib.concatStringsSep ";" (map (y : "unzip ${y}") tarballFiles)}
    for i in */; do cp -rTf $i merged; done
    cd merged
    
    for i in "lib/"jsp-*/*.jar; do 
      ln -s "''${i#lib/}" "lib" || true
    done

    cp [Cc]opyright* doc
    mkdir lib/obsolete
    (
      ls "lib/"log4j-[0-9]*.jar | sort | tac | tail -n +2 ;
      ls "lib/"slf4j-api-[0-9]*.jar | sort | tac | tail -n +2 ;
      ls "lib/"xercesImpl-[0-9]*.jar | sort | tac | tail -n +2 ;
      ls "lib/"arq-[0-9]*.jar | sort | tac | tail -n +2
      ls "lib/"tdb-[0-9]*.jar | sort | tac | tail -n +2
      ls "lib/"jetty-[0-9]*.jar | sort | tac | tail -n +2
      ls "lib/"jetty-util-[0-9]*.jar | sort | tac | tail -n +2
    ) | 
      xargs -I @@ mv @@  lib/obsolete

    mv lib/slf4j-simple-*.jar lib/obsolete

    mkdir -p "$out/share"
    TARGET="$out/share/${name}-dist"
    cp -r . "$TARGET"
    ln -s  "$TARGET/lib" "$out/lib"
    chmod a+x "$TARGET/bin/"*
    mkdir -p "$out/bin"

    echo -e '#! /bin/sh\nls "'"$TARGET"'"/bin' > "$out/bin/jena-list-commands"
    echo '#! /bin/sh' >> "$out/bin/jena-command"
    echo 'export JENAROOT="'"$TARGET"'"' >> "$out/bin/jena-command"
    echo 'export JOSEKIROOT="'"$TARGET"'"' >> "$out/bin/jena-command"
    echo 'export TDBROOT="'"$TARGET"'"' >> "$out/bin/jena-command"
    echo 'export ARQROOT="'"$TARGET"'"' >> "$out/bin/jena-command"
    echo 'sh "'"$TARGET"'"/bin/"$@"' >> "$out/bin/jena-command"

    chmod a+x "$out/bin/"*
  '') ["defEnsureDir" "minInit" "addInputs"];

  trimVersions = a.fullDepEntry (''
  '') ["doDeploy" "minInit"];

  passthru = {
    inherit tarballs;
  };

  meta = {
    description = "An RDF database with SparQL interface over HTTP";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      []; # Builder is just unpacking/mixing what is needed
    license = "free"; # mix of packages under different licenses
    homepage = "http://openjena.org/";
  };
}) x

