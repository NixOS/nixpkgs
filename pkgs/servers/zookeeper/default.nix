{ stdenv, fetchurl, jre, makeWrapper, bash, coreutils, runtimeShell }:

stdenv.mkDerivation rec {
  pname = "zookeeper";
  version = "3.4.13";

  src = fetchurl {
    url = "mirror://apache/zookeeper/${pname}-${version}/${pname}-${version}.tar.gz";
    sha256 = "0karf13zks3ba2rdmma2lyabvmasc04cjmgxp227f0nj8677kvbw";
  };

  buildInputs = [ makeWrapper jre ];

  phases = ["unpackPhase" "installPhase"];

  installPhase = ''
    mkdir -p $out
    cp -R conf docs lib ${pname}-${version}.jar $out
    mkdir -p $out/bin
    cp -R bin/{zkCli,zkCleanup,zkEnv,zkServer}.sh $out/bin
    patchShebangs $out/bin
    substituteInPlace $out/bin/zkServer.sh \
        --replace /bin/echo ${coreutils}/bin/echo
    for i in $out/bin/{zkCli,zkCleanup,zkServer}.sh; do
      wrapProgram $i \
        --set JAVA_HOME "${jre}" \
        --prefix PATH : "${bash}/bin"
    done
    chmod -x $out/bin/zkEnv.sh

    mkdir -p $out/share/zooinspector
    cp -r contrib/ZooInspector/{${pname}-${version}-ZooInspector.jar,icons,lib,config} $out/share/zooinspector

    classpath="$out/${pname}-${version}.jar:$out/share/zooinspector/${pname}-${version}-ZooInspector.jar"
    for jar in $out/lib/*.jar $out/share/zooinspector/lib/*.jar; do
      classpath="$classpath:$jar"
    done

    cat << EOF > $out/bin/zooInspector.sh
    #!${runtimeShell}
    cd $out/share/zooinspector
    exec ${jre}/bin/java -cp $classpath org.apache.zookeeper.inspector.ZooInspector
    EOF
    chmod +x $out/bin/zooInspector.sh
  '';

  meta = with stdenv.lib; {
    homepage = http://zookeeper.apache.org;
    description = "Apache Zookeeper";
    license = licenses.asl20;
    maintainers = with maintainers; [ nathan-gs cstrahan pradeepchhetri ];
    platforms = platforms.unix;
  };
}
