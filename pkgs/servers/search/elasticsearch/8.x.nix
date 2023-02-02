{ elk8Version
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
      x86_64-linux = "d600f984bd4b287e1aa62fef839a3cc4a0f6c604f7652457912822182e78b17b";
      x86_64-darwin = "a1149e5d458b956fa4863cf43eccf8f0b7679474e9b3663fce620f1a211496ee";
      aarch64-linux = "b0d2934bb919058e591787a03f363a930d0b14735a2d5100ca4bca053c152b1e";
      aarch64-darwin = "bbcb1640272e2fbab8701d16f5917b54ded7ac69baa9fad98e2c265e8c37b499";
    };
in
stdenv.mkDerivation rec {
  pname = "elasticsearch";
  version = elk8Version;

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
    			--prefix PATH : "${makeBinPath [ util-linux coreutils gnugrep ]}" \
    			--set ES_JAVA_HOME "${jre_headless}"
    		wrapProgram $out/bin/elasticsearch-plugin --set ES_JAVA_HOME "${jre_headless}"
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
