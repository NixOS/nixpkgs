{lib, stdenv, python2, wordnet, writeScript}:

stdenv.mkDerivation rec {
  version = "542";
  pname = "dict-db-wordnet";

  dontUnpack = true;

  buildInputs = [python2 wordnet];

  installPhase = ''
    mkdir -p $out/share/dictd/
    cd $out/share/dictd

    for i in ${wordnet}/dict/data.*; do
      DATA="$DATA `echo $i | sed -e s,data,index,` $i";
    done

    python ${./wordnet_structures.py} $DATA
    echo en_US.UTF-8 > locale
  '';

  meta = {
    description = "dictd-compatible version of WordNet";

    longDescription =
      '' WordNet® is a large lexical database of English. This package makes
         the wordnet data available to dictd and by extension for lookup with
         the dict command. '';

    homepage = "https://wordnet.princeton.edu/";

    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
