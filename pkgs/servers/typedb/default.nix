{ stdenv, lib, openjdk, system, fetchzip, fetchurl, server-data ? "~/.typedb_home", server-port ? "1729", server-logs ? "~/.typedb_home/logs" }:
let
  typedbVersion = "2.1.1";
  systems = {
    x86_64-linux = {
      src = fetchurl {
        url = "https://github.com/vaticle/typedb/releases/download/2.1.1/typedb-all-linux-2.1.1.tar.gz";
        sha256 = "00wvkiahmrys32ckp6r59bbrzfd7jzsphniyjdj4p9bh7k339gn2";
      };
      dir = "typedb-all-linux-${typedbVersion}";
    };
    x86_64-darwin = {
      src = fetchzip {
        url = "https://github.com/vaticle/typedb/releases/download/2.1.1/typedb-all-mac-2.1.1.zip";
        sha256 = "16hlfy6kh2rnvcralz206q13mghb0rv8wazpg6q3h324p5rdys54";
      };
      dir = "typedb-all-mac-${typedbVersion}";
    };
    x86_64-windows = {
      src = fetchzip {
        url = "https://github.com/vaticle/typedb/releases/download/2.1.1/typedb-all-windows-2.1.1.zip";
        sha256 = "0vd66gfshkg697z07nhy957mwqzlli4r4pmn67hx58n9mkg024kq";
      };
      dir = "typedb-all-windows-${typedbVersion}";
    };
  };

  currentSystem = systems.${system} or throw "unsupported system ${system}";
  typedbDir = currentSystem.dir;
  srcFolder = currentSystem.src;
  javaPatch = ''
    20c20
    < JAVA_BIN=java
    ---
    > JAVA_BIN=${openjdk}/bin/java
  '';
  typedb-properties-patch = ''
    19c19
    < server.data=server/data/
    ---
    > server.data=${server-data}
    22c22
    < server.logs=server/logs/
    ---
    > server.logs=${server-logs}
    24c24
    < server.port=1729
    ---
    > server.port=${server-port}
  '';

in
stdenv.mkDerivation rec {
  pname = "typedb";
  version = typedbVersion;

  src = srcFolder;

  dontBuild = true;

  installPhase = ''
    if [[ "${system}" -eq "x86_64-linux" ]]; then
      tar -xf typedb-all-linux-2.1.1.tar.gz
    fi # the rest is already unpacked by fetchzip

    #patch before install
    echo "${javaPatch}" > typedb_java.patch
    echo "${typedb-properties-patch}" > typedb-properties.patch
    patch ./${typedbDir}/typedb typedb_java.patch
    patch ./${typedbDir}/server/conf/typedb.properties typedb-properties.patch
    mkdir $out
    cp -r ./${typedbDir} $out

  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/typedb --help > /dev/null
    res=`$out/typedb client`
    echo "--"
    echo $res
  '';
  doCheck = true;

  meta = with lib; {
    description = "A distributed knowledge graph, a logical database to organise large and complex networks of data as one body of knowledge";
    longDescription = ''
      TypeDB is a distributed knowledge graph: a logical database to organise large and complex networks of data as one body of knowledge. 
      TypeDB provides the knowledge engineering tools for developers to easily leverage the power of Knowledge Representation and Automated 
      Reasoning when building complex systems. Ultimately, TypeDB serves as the knowledge-base foundation for intelligent systems.
    '';
    homepage = "https://www.grakn.ai/";
    license = licenses.gpl3Plus;
    platforms = lib.attrNames systems;
    maintainers = [ maintainers.haskie ];
  };
}
