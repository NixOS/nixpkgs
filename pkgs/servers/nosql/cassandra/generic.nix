{ stdenv, fetchurl, python, makeWrapper, gawk, bash, getopt, procps
, which, jre, version, sha256, coreutils, ...
}:

let
  libPath = stdenv.lib.makeLibraryPath [ stdenv.cc.cc ];
  binPath = with stdenv.lib; makeBinPath ([
    bash
    getopt
    gawk
    which
    jre
    procps
  ]);
in

stdenv.mkDerivation rec {
  name = "cassandra-${version}";
  inherit version;

  src = fetchurl {
    inherit sha256;
    url = "mirror://apache/cassandra/${version}/apache-${name}-bin.tar.gz";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir $out
    mv * $out

    # Clean up documentation.
    mkdir -p $out/share/doc/${name}
    mv $out/CHANGES.txt \
       $out/LICENSE.txt \
       $out/NEWS.txt \
       $out/NOTICE.txt \
       $out/javadoc \
       $out/share/doc/${name}

    if [[ -d $out/doc ]]; then
      mv "$out/doc/"* $out/share/doc/${name}
      rmdir $out/doc
    fi


    for cmd in bin/cassandra \
               bin/nodetool \
               bin/sstablekeys \
               bin/sstableloader \
               bin/sstablescrub \
               bin/sstableupgrade \
               bin/sstableutil \
               bin/sstableverify \
               tools/bin/cassandra-stress \
               tools/bin/cassandra-stressd \
               tools/bin/sstabledump \
               tools/bin/sstableexpiredblockers \
               tools/bin/sstablelevelreset \
               tools/bin/sstablemetadata \
               tools/bin/sstableofflinerelevel \
               tools/bin/sstablerepairedset \
               tools/bin/sstablesplit \
               tools/bin/token-generator; do

      # check if file exists because some bin tools don't exist across all
      # cassandra versions
      if [ -f $out/$cmd ]; then
        makeWrapper $out/$cmd $out/bin/$(${coreutils}/bin/basename "$cmd") \
          --suffix-each LD_LIBRARY_PATH : ${libPath} \
          --prefix PATH : ${binPath} \
          --set JAVA_HOME ${jre}
      fi
    done

    wrapProgram $out/bin/cqlsh --prefix PATH : ${python}/bin
    '';

  meta = with stdenv.lib; {
    homepage = http://cassandra.apache.org/;
    description = "A massively scalable open source NoSQL database";
    platforms = platforms.unix;
    license = licenses.asl20;
    maintainers = with maintainers; [ cransom ];
  };
}
