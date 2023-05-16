<<<<<<< HEAD
{ coreutils
, fetchurl
, gnugrep
, jre_headless
, lib
, makeBinaryWrapper
, nixosTests
, stdenv
, stdenvNoCC
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "opensearch";
  version = "2.9.0";

  src = fetchurl {
    url = "https://artifacts.opensearch.org/releases/bundle/opensearch/${finalAttrs.version}/opensearch-${finalAttrs.version}-linux-x64.tar.gz";
    hash = "sha256-A9YjwtmacQDC8PrdyP/ai6J+roqmP/bz99rSM3votow=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  buildInputs = [
    jre_headless
  ];
=======
{ lib
, stdenv
, stdenvNoCC
, fetchurl
, makeWrapper
, jre_headless
, util-linux
, gnugrep
, coreutils
, autoPatchelfHook
, zlib
, nixosTests
}:

stdenvNoCC.mkDerivation rec {
  pname = "opensearch";
  version = "2.7.0";

  src = fetchurl {
    url = "https://artifacts.opensearch.org/releases/bundle/opensearch/${version}/opensearch-${version}-linux-x64.tar.gz";
    hash = "sha256-qghqFcwfGDtKVyJW3Hb9Ad8UPh2dfhzxwyCZOp7mGmM=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre_headless util-linux ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -R bin config lib modules plugins $out

    substituteInPlace $out/bin/opensearch \
      --replace 'bin/opensearch-keystore' "$out/bin/opensearch-keystore"

    wrapProgram $out/bin/opensearch \
<<<<<<< HEAD
      --prefix PATH : "${lib.makeBinPath [ gnugrep coreutils ]}" \
=======
      --prefix PATH : "${lib.makeBinPath [ util-linux gnugrep coreutils ]}" \
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc.lib ]}:$out/plugins/opensearch-knn/lib/" \
      --set JAVA_HOME "${jre_headless}"

    wrapProgram $out/bin/opensearch-plugin --set JAVA_HOME "${jre_headless}"
<<<<<<< HEAD
    wrapProgram $out/bin/opensearch-cli --set JAVA_HOME "${jre_headless}"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    runHook postInstall
  '';

  passthru.tests = nixosTests.opensearch;

  meta = {
    description = "Open Source, Distributed, RESTful Search Engine";
    homepage = "https://github.com/opensearch-project/OpenSearch";
<<<<<<< HEAD
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ shyim ];
    platforms = lib.platforms.unix;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
<<<<<<< HEAD
  };
})
=======
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ shyim ];
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
