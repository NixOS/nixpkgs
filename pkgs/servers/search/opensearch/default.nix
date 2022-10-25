{ lib
, stdenvNoCC
, fetchurl
, makeWrapper
, substituteAll
, jre_headless
, util-linux
, gnugrep
, coreutils
, zlib
}:

stdenvNoCC.mkDerivation rec {
  pname = "opensearch";
  version = "2.3.0";

  src = fetchurl {
    url = "https://artifacts.opensearch.org/releases/bundle/opensearch/${version}/${pname}-${version}-linux-x64.tar.gz";
    sha256 = "1jhhz6f58iz5l920avnp0aaai3lfqpqwymk447bjlbvd2arh0rb9";
  };

  patches = [
    ./opensearch-env.patch
  ];

  jre = jre_headless;

  postPatch = ''
    substituteInPlace bin/opensearch \
      --replace 'bin/opensearch-keystore' "$out/bin/opensearch-keystore"

    substituteAllInPlace bin/opensearch-env

    substituteInPlace bin/opensearch-cli --replace \
      "OPENSEARCH_CLASSPATH=\"\$OPENSEARCH_CLASSPATH:\$OPENSEARCH_HOME/\$additional_classpath_directory/*\"" \
      "OPENSEARCH_CLASSPATH=\"\$OPENSEARCH_CLASSPATH:$out/\$additional_classpath_directory/*\""
  '';

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre_headless util-linux ];

  installPhase = ''
    mkdir -p $out
    cp -R bin config lib modules plugins $out

    wrapProgram $out/bin/opensearch \
      --prefix PATH : "${lib.makeBinPath [ util-linux coreutils gnugrep ]}"

    chmod +x $out/bin/*
  '';

  meta = with lib; {
    description = "Open Source, Distributed, RESTful Search Engine";
    homepage = "https://opensearch.org";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dpausp shyim ];
  };
}
