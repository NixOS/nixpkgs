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
    sha256 = "c2be34c63c70a54b64933e5a78f597a7b99fd74a259b3b9918dae70a559c9b03";
  };
  windowsSrc = fetchzip {
    url = "https://github.com/vaticle/typedb/releases/download/2.1.1/typedb-all-windows-2.1.1.zip";
    sha256 = "781201deacc9a2d2e131b65e9249a4f4635e4f491eda03fe49e64da8dd33a66d";
  };
  macSrc = fetchzip {
    url = "https://github.com/vaticle/typedb/releases/download/2.1.1/typedb-all-mac-2.1.1.zip";
    sha256 = "a468df72b9440c38b079f72b8e76060bbe3a0236407caa32db360b388d77149a";
  };
  srcFolder = if stdenv.hostPlatform.isWindows then windowsSrc
              else if stdenv.isDarwin          then macSrc
                                               else linuxSrc ;

in
stdenv.mkDerivation rec {
  pname = "typedb";
  version = typedbVersion;

  src = srcFolder;
  

  buildDepends = [ openjdk ];

  unpackPhase = ''
        sed -i "s%/path/to/java%${openjdk}/bin/java%g" ./typedb_java.patch 
      '';

  patches = [ ./typedb_java.patch ];

  installPhase = ''
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
