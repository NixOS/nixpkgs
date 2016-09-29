{sbt,stdenv, fetchFromGitHub, jdk, makeWrapper}:

with stdenv.lib;
 stdenv.mkDerivation {
    name = "bge-3.1";

    meta = {
      description = "A blockchain analysis server";
      longDescription = "Bitcoin Graph Explorer is a live bitcoin blockchain analysis server including a REST API. It is written in Scala.";
      homepage = "https://bitcoinprivacy.net";
      maintainers =  with maintainers; [ jorgemartinezpizarro stefanwouldgo ];
      license = licenses.asl20;
    };

    buildInputs = [sbt makeWrapper];

    buildPhase =  let
      sbtBootDir = "./.sbt/boot/";
      sbtIvyHome = "/var/tmp/`whoami`/.ivy";
      sbtOpts = "-XX:PermSize=190m -Dsbt.boot.directory=${sbtBootDir} -Dsbt.ivy.home=${sbtIvyHome}";
      in ''
        mkdir -p ${sbtBootDir}
        mkdir -p ${sbtIvyHome}
        sbt ${sbtOpts} assembly publish-local
        cd api
        mkdir -p ${sbtBootDir}
        mkdir -p ${sbtIvyHome}
        sbt ${sbtOpts} assembly
        cd ..
      '';

    installPhase = ''
      mkdir -p $out
      mkdir -p $out/bin/
      cp  ./target/scala-2.11/bge-assembly-3.1.jar $out
      cp bge $out/bin/
      cp  ./api/target/scala-2.11/bgeapi-assembly-1.0.jar $out
      cp api/bgeapi $out/bin/
      wrapProgram $out/bin/bge --suffix LD_LIBRARY_PATH : ${stdenv.cc.cc.lib}/lib                 
    '';

    src = fetchFromGitHub {
      rev = "3.1";
      owner = "bitcoinprivacy";
      repo = "Bitcoin-Graph-Explorer";
      sha256 = "062dfj4vc1r9q2dcppij2k16plv26xabvabn5qa9cq39289797vd";
    };

    JAVA_HOME = "${jdk}";

    shellHook = ''

    export PS1="BGE > " '';
}
