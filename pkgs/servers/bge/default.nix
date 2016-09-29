{sbt,stdenv, fetchgit,jdk, makeWrapper}:

with stdenv.lib;
 stdenv.mkDerivation {
    name = "bge";

    meta = {
     description = "Bitcoin Graph Explorer is a blockchain analysis server";
       homepage = "https://bitcoinprivacy.net";
       maintainers =  with maintainers; [ jorgemartinezpizarro stefanwouldgo ];
       license = licenses.asl20;
    };

    buildPhase = let
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

    src = fetchgit {
    url = "git://github.com/bitcoinprivacy/Bitcoin-Graph-Explorer.git";
    rev = "080bd1f";
    md5 = "3928c2cea051f3a505e21c396c57d054";
    } ;
    JAVA_HOME = "${jdk}";
    shellHook = ''

    export PS1="BGE > " '';
#    LD_LIBRARY_PATH="${stdenv.cc.cc}/lib64";

    buildInputs = [sbt makeWrapper];
}
