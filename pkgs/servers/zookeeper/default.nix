{ lib, stdenv, fetchurl, jdk11_headless, makeWrapper, nixosTests, bash, coreutils }:
let
  # Latest supported LTS JDK for Zookeeper 3.6:
  # https://zookeeper.apache.org/doc/r3.6.3/zookeeperAdmin.html#sc_requiredSoftware
  jre = jdk11_headless;
in
stdenv.mkDerivation rec {
  pname = "zookeeper";
  version = "3.7.1";

  src = fetchurl {
    url = "mirror://apache/zookeeper/${pname}-${version}/apache-${pname}-${version}-bin.tar.gz";
    hash = "sha512-kQNiilB0X6GiibymZv2kqcCOwXxVzxPmaIfnunbpPbrmCh8f/WwQeYvjoWBpNE7LwAzrspvwPZzXCWzNCY7QEQ==";
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
    maintainers = with maintainers; [ nathan-gs cstrahan pradeepchhetri ztzg ];
    platforms = platforms.unix;
  };
}
