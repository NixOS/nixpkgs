{ stdenv, lib, openjdk, fetchurl, graknHome ? "~/.grakn_home", fetchzip}:

let 
  graknVersion = "2.0.0-alpha-9";
  graknDirLinux = "grakn-core-all-linux-${graknVersion}";
  graknDirMac = "grakn-core-all-mac-${graknVersion}";
  graknDirWindows = "grakn-core-all-windows-${graknVersion}";
  graknDir = if stdenv.hostPlatform.isWindows then graknDirWindows
             else if stdenv.isDarwin          then graknDirMac
                                              else graknDirLinux;
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
  srcFolder = if stdenv.hostPlatform.isWindows then windowsSrc
              else if stdenv.isDarwin          then macSrc
                                               else linuxSrc ;
  javaBinPatch = ''NR==20 { rep = gsub(/^JAVA_BIN=java$/,"JAVA_BIN=${openjdk}/bin/java"); }'';
  javaPatches = ''NR~/85|54|79/ { rep+=gsub(/java/,"${openjdk}/bin/java"); }''; 

in
stdenv.mkDerivation rec {
  pname = "grakn";
  version = graknVersion;

  src = srcFolder;

  buildDepends = [ openjdk ];

  buildPhase = ''
    graknFile=./${graknDir}/grakn
    # replace the paths of the grakn boot script with the nix paths
    awk -i inplace '${javaBinPatch} 1 {print $0} END {exit(rep==1?0:1); }' ${graknDir}/grakn
    awk -i inplace 'BEGIN {rep = 0;} ${javaPatches} 1 {print $0} END { print rep; exit(rep==3?0:1); }' ${graknDir}/grakn
  '';
  installPhase = ''
    mkdir $out
    cp -r ./${graknDir} $out
    # add a wrapper script to $out that will move grakn to $graknHome
    # this is necessary because grakn needs a writable environment
    echo "
      # on the first start copy everything to graknHome
      if [ ! -f ${graknHome}/grakn ]; then 
        mkdir -p ${graknHome}; 
        cp -r $out/${graknDir}/* ${graknHome}; 
    
        # correct permissions so that grakn and the user can write there 
        chmod -R u+rw ${graknHome}
        chmod u+x ${graknHome}/grakn
      fi; 
      ${graknHome}/grakn \$@; 
    " > $out/grakn
      
    chmod +x $out/grakn
  '';

  doCheck = true;

  meta = with lib; {
    description = "Grakn Core: The Knowledge Graph";
    longDescription = ''
      Grakn is a distributed knowledge graph: 
      a logical database to organise large and 
      complex networks of data as one body of knowledge.
    '';
    homepage = "https://www.grakn.ai/";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.haskie ];
  };
}
