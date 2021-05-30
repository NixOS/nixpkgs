{ stdenv, lib, openjdk, fetchurl, typedbHome ? "~/.typedb_home", fetchzip}:

let 
  typedbVersion = "2.1.1";
  typedbDirLinux = "typedb-all-linux-${typedbVersion}";
  typedbDirMac = "typedb-all-mac-${typedbVersion}";
  typedbDirWindows = "typedb-all-windows-${typedbVersion}";
  typedbDir = if stdenv.hostPlatform.isWindows then typedbDirWindows
              else if stdenv.isDarwin          then typedbDirMac
                                               else typedbDirLinux;
  linuxSrc = builtins.fetchTarball {
    url = "https://github.com/vaticle/typedb/releases/download/2.1.1/typedb-all-linux-2.1.1.tar.gz";
    sha256 = "15nwm2dr68p67c2xcqigs66gd679j1zr72gqv7qxgvflwyvyz8fb";
  };
  windowsSrc = fetchzip {
    url = "https://github.com/vaticle/typedb/releases/download/2.1.1/typedb-all-windows-2.1.1.zip";
    sha256 = "0vd66gfshkg697z07nhy957mwqzlli4r4pmn67hx58n9mkg024kq";
  };
  macSrc = fetchzip {
    url = "https://github.com/vaticle/typedb/releases/download/2.1.1/typedb-all-mac-2.1.1.zip";
    sha256 = "16hlfy6kh2rnvcralz206q13mghb0rv8wazpg6q3h324p5rdys54";
  };
  srcFolder = if stdenv.hostPlatform.isWindows then windowsSrc
              else if stdenv.isDarwin          then macSrc
                                               else linuxSrc ;
  javaPatch = ''
        20c20
        < JAVA_BIN=java
        ---
        > JAVA_BIN=${openjdk}/bin/java
        '';

in
stdenv.mkDerivation rec {
  pname = "typedb";
  version = typedbVersion;

  src = srcFolder;
    
  phases = [ "installPhase" ];

  buildDepends = [ openjdk ];

  installPhase = ''
    echo "here"
    ls -lah ../tmp
    echo "--"
    #patch before install
    echo "${javaPatch}" > typedb_java.patch
    patch ./${typedbDir}/typedb typedb_java.patch

    mkdir $out
    cp -r ./${typedbDir} $out
    # add a wrapper script to $out that will move typedb to $typedb
    # this is necessary because typedb needs a writable environment
    echo "
      # on the first start copy everything to typedbHome
      if [ ! -f ${typedbHome}/typedb ]; then 
        mkdir -p ${typedbHome}; 
        cp -r $out/${typedbDir}/* ${typedbHome}; 
    
        # correct permissions so that typedb and the user can write there 
        chmod -R u+rw ${typedbHome}
        chmod u+x ${typedbHome}/typedb
      fi; 
      ${typedbHome}/typedb \$@; 
    " > $out/typedb

    chmod +x $out/typedb
  '';

  doCheck = true;

  meta = with lib; {
    description = "TypeDB is a distributed knowledge graph: a logical database to organise large and complex networks of data as one body of knowledge.";
    longDescription = ''
        TypeDB is a distributed knowledge graph: a logical database to organise large and complex networks of data as one body of knowledge. 
        TypeDB provides the knowledge engineering tools for developers to easily leverage the power of Knowledge Representation and Automated 
        Reasoning when building complex systems. Ultimately, TypeDB serves as the knowledge-base foundation for intelligent systems.
    '';
    homepage = "https://www.grakn.ai/";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.haskie ];
  };
}
