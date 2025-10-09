{
  lib,
  stdenv,
  fetchurl,
  python311Packages,
  makeWrapper,
  gawk,
  bash,
  getopt,
  procps,
  which,
  jre,
  nixosTests,
  # generation is the attribute version suffix such as 4 in pkgs.cassandra_4
  generation,
  version,
  sha256,
  extraMeta ? { },
  callPackage,
  ...
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

stdenv.mkDerivation rec {
  pname = "cassandra";
  inherit version;

  src = fetchurl {
    inherit sha256;
    url = "mirror://apache/cassandra/${version}/apache-cassandra-${version}-bin.tar.gz";
  };

  pythonPath = with python311Packages; [ cassandra-driver ];

  nativeBuildInputs = [ python311Packages.wrapPython ];

  buildInputs = [ python311Packages.python ] ++ pythonPath;

  installPhase = ''
    runHook preInstall

    mkdir $out
    mv * $out

    # Clean up documentation.
    mkdir -p $out/share/doc/${pname}-${version}
    mv $out/CHANGES.txt \
       $out/LICENSE.txt \
       $out/NEWS.txt \
       $out/NOTICE.txt \
       $out/share/doc/${pname}-${version}

    if [[ -d $out/doc ]]; then
      mv "$out/doc/"* $out/share/doc/${pname}-${version}
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

    runHook postInstall
  '';

  postFixup = ''
    # Remove cassandra bash script wrapper.
    # The wrapper searches for a suitable python version and is not necessary with Nix.
    rm $out/bin/cqlsh
    # Make "cqlsh.py" accessible by invoking "cqlsh"
    ln -s $out/bin/cqlsh.py $out/bin/cqlsh
    wrapPythonPrograms
  '';

  passthru = {
    tests =
      let
        test = nixosTests."cassandra_${generation}";
      in
      {
        nixos =
          assert test.testPackage.version == version;
          test;
      };

    updateScript = callPackage ./update-script.nix { inherit generation; };
  };

  meta =
    with lib;
    {
      homepage = "https://cassandra.apache.org/";
      description = "Massively scalable open source NoSQL database";
      platforms = platforms.unix;
      license = licenses.asl20;
      sourceProvenance = with sourceTypes; [
        binaryBytecode
        binaryNativeCode # bundled dependency libsigar
      ];
      maintainers = [ maintainers.roberth ];
    }
    // extraMeta;
}
