{ stdenv, lib, openjdk, which, system, fetchzip, fetchurl, callPackage
, server-data ? "~/.typedb_home", server-port ? "1729"
, server-logs ? "~/.typedb_home/logs" }:
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
        sha256 = "1njvssv9h0m13jz0ims96nfl1fjyk7lv8jdb6apcqpbkw7ykz8h8";
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

  currentSystem = systems.${system} or (throw "unsupported system ${system}");
  typedbDir = currentSystem.dir;
  srcFolder = currentSystem.src;
  javaPatch = ''
    20c20
    < JAVA_BIN=java
    ---
    > JAVA_BIN=${openjdk}/bin/java
    32c32
    <     which "$'' + "{JAVA_BIN}\" > /dev/null\n" +
  "---\n" +
  ">     ${which}/bin/which \"$" + "{JAVA_BIN}\" > /dev/null";

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
  typedb-wrapper-patch = ''
    2c2
    <   TYPEDB_SERVER_DATA="__SERVER_DATA__"
    ---
    >   TYPEDB_SERVER_DATA="${server-data}"
    6c6
    <   TYPEDB_SERVER_LOGS="__SERVER_LOGS__"
    ---
    >   TYPEDB_SERVER_LOGS="${server-logs}"
    10c10
    <   TYPEDB_SERVER_PORT="__SERVER_PORT__"
    ---
    >   TYPEDB_SERVER_PORT="${server-port}"
  '';
  typedbWrapper = ./typedbWrapper.sh;

in
stdenv.mkDerivation rec {
  pname = "typedb";
  version = typedbVersion;

  src = srcFolder;

  dontBuild = true;

  /*
    in preparation for the coming change of properties file parsing
    allowing for environment variable reading :
    > echo "${typedb-properties-patch}" > typedb-properties.patch
    > patch ./server/conf/typedb.properties typedb-properties.patch
  */
  installPhase = ''
    #patch before install
    echo '${javaPatch}' > typedb_java.patch
    echo '${typedb-wrapper-patch}' > typedb_wrapper.patch
    patch ./typedb typedb_java.patch

    mkdir $out
    cp -r ./* $out
    mkdir $out/bin

    cat ${typedbWrapper} > $out/bin/typedb
    echo "$out/typedb \"\$@\" --data=\$TYPEDB_SERVER_DATA --logs=\$TYPEDB_SERVER_LOGS --port=\$TYPEDB_SERVER_PORT" >> $out/bin/typedb
    patch $out/bin/typedb typedb_wrapper.patch

    chmod u+x $out/bin/typedb
    rm typedb_java.patch
    rm typedb_wrapper.patch
  '';

  passthru.tests = {
    simple-execution = callPackage ./tests.nix { };
  };

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
