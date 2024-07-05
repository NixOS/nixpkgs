{ lib, stdenv, fetchurl, jdk11_headless, makeWrapper, nixosTests, bash, coreutils }:
let
  # Latest supported LTS JDK for Zookeeper 3.9:
  # https://zookeeper.apache.org/doc/r3.9.2/zookeeperAdmin.html#sc_requiredSoftware
  jre = jdk11_headless;
in
stdenv.mkDerivation rec {
  pname = "zookeeper";
  version = "3.9.2";

  src = fetchurl {
    url = "mirror://apache/zookeeper/${pname}-${version}/apache-${pname}-${version}-bin.tar.gz";
    hash = "sha512-K1rgLWGKJ8qM1UkkhV1TRCY7fZ3udgGB+dZrr6kjAyTSrTF4aJXwZUyWncONSj0Ad/dMw3a1i1+i+5S+satEXw==";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -R conf docs lib $out
    mkdir -p $out/bin
    cp -R bin/{zkCli,zkCleanup,zkEnv,zkServer,zkSnapShotToolkit,zkTxnLogToolkit}.sh $out/bin
    patchShebangs $out/bin
    substituteInPlace $out/bin/zkServer.sh \
        --replace-fail /bin/echo ${coreutils}/bin/echo
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
    changelog = "https://zookeeper.apache.org/doc/r${version}/releasenotes.html";
    license = licenses.asl20;
    maintainers = with maintainers; [ nathan-gs pradeepchhetri ztzg ];
    platforms = platforms.unix;
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
  };
}
