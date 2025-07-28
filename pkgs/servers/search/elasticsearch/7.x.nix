{
  elk7Version,
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jre_headless,
  util-linux,
  gnugrep,
  coreutils,
  autoPatchelfHook,
  zlib,
}:

let
  info = lib.splitString "-" stdenv.hostPlatform.system;
  arch = lib.elemAt info 0;
  plat = lib.elemAt info 1;
  hashes = {
    x86_64-linux = "sha512-xlbdx/fFQxilECdDiN80U+s+huBowo9Qf5tDIYwZ1z9gUCriNL0rMNDkvzUDL73BEI3WMFMqHdbi3cn7b5l9gA==";
    x86_64-darwin = "sha512-hiTSp7lO/x6tBYiUgKglce39k/oxT4hUlTAoC50pYFiqANALAN+2E0HtZdvsMmrOn4aGLxh+SKVglMHfrGxr+g==";
    aarch64-linux = "sha512-MPrDfBMcwNCgWW8dpOeAtlz9Odfk/0z8i+Rn08hTp35kU849KdPQLTmexlvnf/jVwqfwzN2xWJtNF0sQO26pUA==";
    aarch64-darwin = "sha512-uq5VVwvbOX4Rv32iLFw+RalFPBxQqA+1hBjFw3svzOaD1caOOrGHD4lJVHFxsFw0xl//AZuSG7S3r7Eh9AmWvQ==";
  };
in
stdenv.mkDerivation rec {
  pname = "elasticsearch";
  version = elk7Version;

  src = fetchurl {
    url = "https://artifacts.elastic.co/downloads/elasticsearch/${pname}-${version}-${plat}-${arch}.tar.gz";
    hash = hashes.${stdenv.hostPlatform.system} or (throw "Unknown architecture");
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

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optional (!stdenv.hostPlatform.isDarwin) autoPatchelfHook;

  buildInputs = [
    jre_headless
    util-linux
    zlib
  ];

  runtimeDependencies = [ zlib ];

  installPhase = ''
    mkdir -p $out
    cp -R bin config lib modules plugins $out

    chmod +x $out/bin/*

    substituteInPlace $out/bin/elasticsearch \
      --replace 'bin/elasticsearch-keystore' "$out/bin/elasticsearch-keystore"

    wrapProgram $out/bin/elasticsearch \
      --prefix PATH : "${
        lib.makeBinPath [
          util-linux
          coreutils
          gnugrep
        ]
      }" \
      --set JAVA_HOME "${jre_headless}"

    wrapProgram $out/bin/elasticsearch-plugin --set JAVA_HOME "${jre_headless}"
  '';

  passthru = {
    enableUnfree = true;
  };

  meta = with lib; {
    description = "Open Source, Distributed, RESTful Search Engine";
    sourceProvenance = with sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    license = licenses.elastic20;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      apeschar
      basvandijk
    ];
  };
}
