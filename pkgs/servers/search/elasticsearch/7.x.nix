{ elk7Version
, lib
, stdenv
, fetchurl
, makeWrapper
, jre_headless
, util-linux
, gnugrep
, coreutils
, autoPatchelfHook
, zlib
}:

with lib;
let
  info = splitString "-" stdenv.hostPlatform.system;
  arch = elemAt info 0;
  plat = elemAt info 1;
  shas =
    {
      x86_64-linux   = "7a2013e43c7fc39e86a31a733cc74c587ef2bba0c013f95ce874f98b488a4f8f0e6fb254a1eedd5c0b0e210aed9a0195f7358fa9653c890e234413ff93190807";
      x86_64-darwin  = "e6f49e7c0f59e260b3e3d43e57375c9352976c4f51118005e3a9127f41b59f95e51ea158cd318e99410e6d98464ea1f84432c905d12a84b8f68b2ce35905f944";
      aarch64-linux  = "f2790f49b79c381246bbf87431919452af93aa4fd8aa6bc9c1f9031e7ed5d9c649f5bab867c28a7d1602e2285d3f4a5f78f809ac05744b02ad67d68610bb677d";
      aarch64-darwin = "75b66b60650bb82dc517f4a594fa40816d3becb92bf3b349f3e8324cc6b297c8bcacebc08e7661891fd4ede03a099fea56c1509291804dd03345717c36564172";
    };
in
stdenv.mkDerivation rec {
  pname = "elasticsearch";
  version = elk7Version;

  src = fetchurl {
    url = "https://artifacts.elastic.co/downloads/elasticsearch/${pname}-${version}-${plat}-${arch}.tar.gz";
    sha512 = shas.${stdenv.hostPlatform.system} or (throw "Unknown architecture");
  };

  patches = [ ./es-home-6.x.patch ];

  postPatch = ''
    substituteInPlace bin/elasticsearch-env --replace \
      "ES_CLASSPATH=\"\$ES_HOME/lib/*\"" \
      "ES_CLASSPATH=\"$out/lib/*\""

    substituteInPlace bin/elasticsearch-cli --replace \
      "ES_CLASSPATH=\"\$ES_CLASSPATH:\$ES_HOME/\$additional_classpath_directory/*\"" \
      "ES_CLASSPATH=\"\$ES_CLASSPATH:$out/\$additional_classpath_directory/*\""
  '';

  nativeBuildInputs = [ makeWrapper ]
    ++ lib.optional (!stdenv.hostPlatform.isDarwin) autoPatchelfHook;

  buildInputs = [ jre_headless util-linux zlib ];

  runtimeDependencies = [ zlib ];

  installPhase = ''
    mkdir -p $out
    cp -R bin config lib modules plugins $out

    chmod +x $out/bin/*

    substituteInPlace $out/bin/elasticsearch \
      --replace 'bin/elasticsearch-keystore' "$out/bin/elasticsearch-keystore"

    wrapProgram $out/bin/elasticsearch \
      --prefix PATH : "${makeBinPath [ util-linux coreutils gnugrep ]}" \
      --set JAVA_HOME "${jre_headless}"

    wrapProgram $out/bin/elasticsearch-plugin --set JAVA_HOME "${jre_headless}"
  '';

  passthru = { enableUnfree = true; };

  meta = {
    description = "Open Source, Distributed, RESTful Search Engine";
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    license = licenses.elastic;
    platforms = platforms.unix;
    maintainers = with maintainers; [ apeschar basvandijk ];
  };
}
