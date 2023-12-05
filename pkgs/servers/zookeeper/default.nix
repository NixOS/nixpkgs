{ lib, stdenv, fetchurl, jdk11_headless, makeWrapper, nixosTests, bash, coreutils }:
let
  # Latest supported LTS JDK for Zookeeper 3.7:
  # https://zookeeper.apache.org/doc/r3.7.2/zookeeperAdmin.html#sc_requiredSoftware
  jre = jdk11_headless;
in
stdenv.mkDerivation rec {
  pname = "zookeeper";
  version = "3.7.2";

  src = fetchurl {
    url = "mirror://apache/zookeeper/${pname}-${version}/apache-${pname}-${version}-bin.tar.gz";
    hash = "sha512-avv8GvyLk3AoG9mGLzfbscuV7FS7LtQ3GDGqXA8Iz+53UFC9V85fwINuYa8n7tnwB29UuYmX3Q4VFZGWBW5S6g==";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];

  installPhase = ''
    runHook preInstall
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
    runHook postInstall
  '';

  passthru = {
    tests = {
      nixos = nixosTests.zookeeper;
    };
    inherit jre;
  };

  meta = with lib; {
    homepage = "https://zookeeper.apache.org";
    description = "Apache Zookeeper";
    license = licenses.asl20;
    maintainers = with maintainers; [ nathan-gs pradeepchhetri ztzg ];
    platforms = platforms.unix;
  };
}
