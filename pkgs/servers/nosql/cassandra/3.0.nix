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

  version = "3.0.8";
  sha256 = "02chk8q3pbl0y6rijfk2gbd0p1ani8daypsx9m9ingqkdx8ajljq";

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

    for cmd in cassandra nodetool sstableloader sstableupgrade
      do wrapProgram $out/bin/$cmd \
        --set JAVA_HOME ${jre} \
        --prefix PATH : ${stdenv.lib.makeBinPath [ bash getopt gawk procps ]}
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
