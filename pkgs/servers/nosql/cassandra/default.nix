{ stdenv , fetchurl , jre , python , makeWrapper , gawk , bash , getopt , procps}:

let

  common = { version, sha256 }: stdenv.mkDerivation (rec {
    name = "cassandra-${version}";

    src = fetchurl {
      url = "mirror://apache/cassandra/${version}/apache-${name}-bin.tar.gz";
      inherit sha256;
    };

    nativeBuildInputs = [ makeWrapper ];

    installPhase = ''
      mkdir $out
      mv * $out

      for cmd in cassandra nodetool sstable*
        do wrapProgram $out/bin/$cmd \
          --set JAVA_HOME ${jre} \
          --prefix PATH : ${bash}/bin \
          --prefix PATH : ${getopt}/bin \
          --prefix PATH : ${gawk}/bin \
          --prefix PATH : ${procps}/bin
      done

      wrapProgram $out/bin/cqlsh --prefix PATH : ${python}/bin
      '';

    meta = with stdenv.lib; {
      homepage = http://cassandra.apache.org/;
      description = "A massively scalable open source NoSQL database";
      platforms = platforms.all;
      license = licenses.asl20;
      maintainers = with maintainers; [ nckx rushmorem markus1189 ];
    };
  });

in {

 cassandra_2_1 = common {
    version = "2.1.13";
    sha256 = "09b3vf5jsv70xlfimj30v8l1zw7c5xdgpw5fpmn6jh8n3gigybqh";
  };

  cassandra_2_2 = common {
    version = "2.2.5";
    sha256 = "07sg2qz5d18cn92klv2212ck32gmw2jsfwvsz3av2gsls142978l";
  };

  cassandra_3_0 = common {
    version = "3.0.4";
    sha256 = "1l2aw94zrygimklw9a523jfcv73gq5zdz3azrp1rwq7n2anjl3k2";
  };
}
