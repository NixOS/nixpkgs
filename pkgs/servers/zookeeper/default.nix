{ stdenv, fetchurl, jre, makeWrapper, bash, coreutils }:

stdenv.mkDerivation rec {
  name = "zookeeper-${version}";
  version = "3.4.9";

  src = fetchurl {
    url = "mirror://apache/zookeeper/${name}/${name}.tar.gz";
    sha256 = "0dgmja1lm7qn92x2xfmz5qj2k6sj2f6yzyj3a55r7iv1590l1wz7";
  };

  buildInputs = [ makeWrapper jre ];

  phases = ["unpackPhase" "installPhase"];

  installPhase = ''
    mkdir -p $out
    cp -R conf docs lib ${name}.jar $out
    mkdir -p $out/bin
    cp -R bin/{zkCli,zkCleanup,zkEnv,zkServer}.sh $out/bin
    for i in $out/bin/{zkCli,zkCleanup}.sh; do
      wrapProgram $i \
        --set JAVA_HOME "${jre}" \
        --prefix PATH : "${bash}/bin"
    done
    substituteInPlace $out/bin/zkServer.sh \
        --replace /bin/echo ${coreutils}/bin/echo \
        --replace "/usr/bin/env bash" ${bash}/bin/bash
    chmod -x $out/bin/zkEnv.sh

    mkdir -p $out/share/zooinspector
    cp -r contrib/ZooInspector/{${name}-ZooInspector.jar,icons,lib,config} $out/share/zooinspector

    classpath="$out/${name}.jar:$out/share/zooinspector/${name}-ZooInspector.jar"
    for jar in $out/lib/*.jar $out/share/zooinspector/lib/*.jar; do
      classpath="$classpath:$jar"
    done

    cat << EOF > $out/bin/zooInspector.sh
    #!${stdenv.shell}
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
