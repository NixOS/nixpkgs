{ stdenv
, fetchurl
, jre
, python
, makeWrapper
, gawk
, bash
, getopt
, procps
}:

let

  version = "2.1.15";
  sha256 = "1yc6r4gmxz9c4zghzn6bz5wswz7dz61w7p4x9s5gqnixfp2mlapp";

in

stdenv.mkDerivation rec {
  name = "cassandra-${version}";

  src = fetchurl {
    inherit sha256;
    url = "mirror://apache/cassandra/${version}/apache-${name}-bin.tar.gz";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir $out
    mv * $out

    for cmd in cassandra nodetool sstablekeys sstableloader sstableupgrade
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
    maintainers = with maintainers; [ nckx rushmorem ];
  };
}
