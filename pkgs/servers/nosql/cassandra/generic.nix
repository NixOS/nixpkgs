{ lib
, stdenv
, fetchurl
, python2
, makeWrapper
, gawk
, bash
, getopt
, procps
, which
, jre
, nixosTests
  # generation is the attribute version suffix such as 3_11 in pkgs.cassandra_3_11
, generation
, version
, sha256
, extraMeta ? { }
, callPackage
, ...
}:

let
  libPath = lib.makeLibraryPath [ stdenv.cc.cc ];
  binPath = lib.makeBinPath [
    bash
    getopt
    gawk
    which
    jre
    procps
  ];
in

stdenv.mkDerivation (finalAttrs: {
  pname = "cassandra";
  inherit version;

  src = fetchurl {
    inherit sha256;
    url = "mirror://apache/cassandra/${finalAttrs.version}/apache-cassandra-${finalAttrs.version}-bin.tar.gz";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir $out
    mv * $out

    # Clean up documentation.
    mkdir -p $out/share/doc/${finalAttrs.pname}-${finalAttrs.version}
    mv $out/CHANGES.txt \
       $out/LICENSE.txt \
       $out/NEWS.txt \
       $out/NOTICE.txt \
       $out/share/doc/${finalAttrs.pname}-${finalAttrs.version}

    if [[ -d $out/doc ]]; then
      mv "$out/doc/"* $out/share/doc/${finalAttrs.pname}-${finalAttrs.version}
      rmdir $out/doc
    fi


    for cmd in bin/cassandra \
               bin/nodetool \
               bin/sstablekeys \
               bin/sstableloader \
               bin/sstablescrub \
               bin/sstableupgrade \
               bin/sstableutil \
               bin/sstableverify; do
      # Check if file exists because some don't exist across all versions
      if [ -f $out/$cmd ]; then
        wrapProgram $out/bin/$(basename "$cmd") \
          --suffix-each LD_LIBRARY_PATH : ${libPath} \
          --prefix PATH : ${binPath} \
          --set JAVA_HOME ${jre}
      fi
    done

    for cmd in tools/bin/cassandra-stress \
               tools/bin/cassandra-stressd \
               tools/bin/sstabledump \
               tools/bin/sstableexpiredblockers \
               tools/bin/sstablelevelreset \
               tools/bin/sstablemetadata \
               tools/bin/sstableofflinerelevel \
               tools/bin/sstablerepairedset \
               tools/bin/sstablesplit \
               tools/bin/token-generator; do
      # Check if file exists because some don't exist across all versions
      if [ -f $out/$cmd ]; then
        makeWrapper $out/$cmd $out/bin/$(basename "$cmd") \
          --suffix-each LD_LIBRARY_PATH : ${libPath} \
          --prefix PATH : ${binPath} \
          --set JAVA_HOME ${jre}
      fi
    done

    wrapProgram $out/bin/cqlsh --prefix PATH : ${python2}/bin

    runHook postInstall
  '';

  passthru = {
    tests = {
      nixos = nixosTests.cassandra.extend {
        matrix.version.enable = false;
        params.testPackage = finalAttrs.finalPackage;
      };
    };

    updateScript = callPackage ./update-script.nix { inherit generation; };
  };

  meta = with lib; {
    homepage = "https://cassandra.apache.org/";
    description = "A massively scalable open source NoSQL database";
    platforms = platforms.unix;
    license = licenses.asl20;
    maintainers = [ maintainers.roberth ];
  } // extraMeta;
})
