{ stdenv
, fetchurl
, jre
, python
, makeWrapper
, gawk
, bash
, getopt
}:

let version = "2.1.2";
in stdenv.mkDerivation rec {
  name = "cassandra-${version}";

  src = fetchurl {
    url = "http://apache.cs.utah.edu/cassandra/${version}/apache-${name}-bin.tar.gz";
    sha256 = "1glpv3d1c63ccqnfjzz76cxb508qyvbgva26h5j7k8dd5av84lcr";
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir $out
    mv * $out

    for cmd in cassandra nodetool sstablekeys sstableloader sstableupgrade
      do wrapProgram $out/bin/$cmd \
        --set JAVA_HOME ${jre} \
        --prefix PATH : ${bash}/bin \
        --prefix PATH : ${getopt}/bin \
        --prefix PATH : ${gawk}/bin
    done

    wrapProgram $out/bin/cqlsh --prefix PATH : ${python}/bin
    '';

  meta = with stdenv.lib; {
    homepage = http://cassandra.apache.org/;
    description = "A massively scalable open source NoSQL database";
    platforms = with platforms; all;
    license = with licenses; asl20;
    maintainers = with maintainers; [ nckx ];
  };
}
