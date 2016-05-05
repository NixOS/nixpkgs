{ stdenv, fetchurl, jre, makeWrapper, bash }:

stdenv.mkDerivation rec {
  name = "zookeeper-3.4.6";

  src = fetchurl {
    url = "mirror://apache/zookeeper/${name}/${name}.tar.gz";
    sha256 = "01b3938547cd620dc4c93efe07c0360411f4a66962a70500b163b59014046994";
  };

  buildInputs = [ makeWrapper jre ];

  phases = ["unpackPhase" "installPhase"];

  installPhase = ''
    mkdir -p $out
    cp -R conf docs lib ${name}.jar $out
    mkdir -p $out/bin
    cp -R bin/{zkCli,zkCleanup,zkEnv}.sh $out/bin
    for i in $out/bin/{zkCli,zkCleanup}.sh; do
      wrapProgram $i \
        --set JAVA_HOME "${jre}" \
        --prefix PATH : "${bash}/bin"
    done
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
    homepage = "http://zookeeper.apache.org";
    description = "Apache Zookeeper";
    license = licenses.asl20;
    maintainers = with maintainers; [ nathan-gs cstrahan ];
    platforms = platforms.unix;
  };
}
