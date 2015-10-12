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

  version = "2.1.10";
  sha256 = "0cpb16206dkpiza8cp0adsv87sw0crglm9b4dbz2cka1mmqvs28h";

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
    platforms = with platforms; all;
    license = licenses.asl20;
    maintainers = with maintainers; [ nckx rushmorem ];
  };
}
