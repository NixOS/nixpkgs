{ stdenv, openjdk, fetchurl, graknHome?"~/.grakn_home", fetchzip}:
let graknDir = "grakn-core-all-linux-2.0.0-alpha-9";
in
stdenv.mkDerivation rec {
    pname = "grakn";
    version = "1.8.4";

    linuxSrc = builtins.fetchTarball {
        url = "https://github.com/graknlabs/grakn/releases/download/2.0.0-alpha-9/grakn-core-all-linux-2.0.0-alpha-9.tar.gz";
        sha256 = "04g5n6nhffs1gc8gzmrblz6sv74sgi9c9vk6b3dsh2133zm8h8mk";
    };

    windowsSrc = fetchzip {
        url = "https://github.com/graknlabs/grakn/releases/download/2.0.0-alpha-9/grakn-core-all-windows-2.0.0-alpha-9.zip";
        sha256 = "05gzpxwyscj63lqcl2nydfzqq7911a0wai2gm6hzqjqdadl9r363";
    };
 
    macSrc = fetchzip {
        url = "https://github.com/graknlabs/grakn/releases/download/2.0.0-alpha-9/grakn-core-all-mac-2.0.0-alpha-9.zip";
        sha256 = "1w51anjd1gwsjqawjkd6yx4m0z5vd1cryap2i30ysm5jca8afn5j";
    };

    src = if stdenv.hostPlatform.isWindows
            then windowsSrc
            else if stdenv.isDarwin 
                then macSrc
                else linuxSrc ;

    buildDepends = [ openjdk ];
    buildPhase = ''
        graknFile=./${graknDir}/grakn
        sed -i "20s#^JAVA_BIN=java\$#JAVA_BIN=${openjdk}/bin/java#" $graknFile
        sed -i "85s#java#${openjdk}/bin/java#" $graknFile
        sed -i "54s#java#${openjdk}/bin/java#" $graknFile
        sed -i "79s#java#${openjdk}/bin/java#" $graknFile
        '';
    installPhase = ''
        mkdir $out
        cp -r ./${graknDir} $out
        echo "
if [ ! -f ${graknHome}/grakn ]; then 
    mkdir -p ${graknHome}; 
    cp -r $out/${graknDir}/* ${graknHome}; 
    chmod -R u+rw ${graknHome}
    chmod u+x ${graknHome}/grakn
fi; 
${graknHome}/grakn \$@; 
            " > $out/grakn
        chmod +x $out/grakn
        cd $out
        '';

    doCheck = true;

    meta = with stdenv.lib; {
        description = "Grakn Core: The Knowledge Graph";
        longDescription = ''
            Grakn is a distributed knowledge graph: 
            a logical database to organise large and 
            complex networks of data as one body of knowledge.
        '';
        homepage = "https://www.grakn.ai/";
        license = licenses.gpl3Plus;
        platforms = platforms.all;
    };
}
