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

let
  info = lib.splitString "-" stdenv.hostPlatform.system;
  arch = lib.elemAt info 0;
  plat = lib.elemAt info 1;
  shas =
    {
      x86_64-linux   = "7281b79f2bf7421c2d71ab4eecdfd517b86b6788d1651dad315198c564284ea9";
      x86_64-darwin  = "6d2343171a0d384910312220aae3512f45e3d3d900557b736c139b8363a008e4";
      aarch64-linux  = "3153820d53a454513b534765fef68ce1f61a2dd92d4dae7428a1220bb3ce8fe5";
      aarch64-darwin = "e62af7486c1041d3f1648646671d5c665e1abffd696cd2a5d96c2a5aaabe38f8";
    };
in
stdenv.mkDerivation rec {
  pname = "elasticsearch";
  version = elk7Version;

  src = fetchurl {
    url = "https://artifacts.elastic.co/downloads/elasticsearch/${pname}-${version}-${plat}-${arch}.tar.gz";
    sha256 = shas.${stdenv.hostPlatform.system} or (throw "Unknown architecture");
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
      --prefix PATH : "${lib.makeBinPath [ util-linux coreutils gnugrep ]}" \
      --set JAVA_HOME "${jre_headless}"

    wrapProgram $out/bin/elasticsearch-plugin --set JAVA_HOME "${jre_headless}"
  '';

  passthru = { enableUnfree = true; };

  meta = with lib; {
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
