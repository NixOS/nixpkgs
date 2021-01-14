{ lib, stdenv, fetchurl, jre, makeWrapper, bash, coreutils, runtimeShell }:

stdenv.mkDerivation rec {
  pname = "zookeeper";
  version = "3.6.2";

  src = fetchurl {
    url = "mirror://apache/zookeeper/${pname}-${version}/apache-${pname}-${version}-bin.tar.gz";
    sha512 = "caff5111bb6876b7124760bc006e6fa2523efa54b99321a3c9cd8192ea0d5596abc7d70a054b1aac9b20a411407dae7611c7aba870c23bff28eb1643ba499199";
  };

  buildInputs = [ makeWrapper jre ];

  phases = ["unpackPhase" "installPhase"];

  installPhase = ''
    mkdir -p $out
    cp -R conf docs lib $out
    # Without this, zkCli.sh tries creating a log file in the Nix store.
    substituteInPlace $out/conf/log4j.properties \
        --replace 'INFO, RFAAUDIT' 'INFO, CONSOLE'
    mkdir -p $out/bin
    cp -R bin/{zkCli,zkCleanup,zkEnv,zkServer,zkSnapShotToolkit,zkTxnLogToolkit}.sh $out/bin
    patchShebangs $out/bin
    substituteInPlace $out/bin/zkServer.sh \
        --replace /bin/echo ${coreutils}/bin/echo
    for i in $out/bin/{zkCli,zkCleanup,zkServer,zkSnapShotToolkit,zkTxnLogToolkit}.sh; do
      wrapProgram $i \
        --set JAVA_HOME "${jre}" \
        --prefix PATH : "${bash}/bin"
    done
    chmod -x $out/bin/zkEnv.sh
  '';

  meta = with lib; {
    homepage = "https://zookeeper.apache.org";
    description = "Apache Zookeeper";
    license = licenses.asl20;
    maintainers = with maintainers; [ nathan-gs cstrahan pradeepchhetri ztzg ];
    platforms = platforms.unix;
  };
}
