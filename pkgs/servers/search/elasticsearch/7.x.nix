{ elk7Version
, enableUnfree ? true
, stdenv
, fetchurl
, makeWrapper
, jre_headless
, utillinux, gnugrep, coreutils
, autoPatchelfHook
, zlib
}:

with stdenv.lib;
let
  info = splitString "-" stdenv.hostPlatform.system;
  arch = elemAt info 0;
  plat = elemAt info 1;
  shas =
    if enableUnfree
    then {
      "x86_64-linux"  = "1jkfllafcjqhfydsy90jx2ghpv5cmm6gabv206niwg9qc6y6r1ik";
      "x86_64-darwin" = "1lgyxq3yahdww0wpqmpc1mz57kmk5hy2drb1dha69k9l0ibmjf18";
    }
    else {
      "x86_64-linux"  = "0pg22wi2xcjla44azfvn9c58r4xq3x9jiwh7qb0d8f3nv30vfd10";
      "x86_64-darwin" = "0d9xg3bf06mr7mw2bd16gb2xrfjncrhj19846rrj4j5gb2qjz0x2";
    };
in
stdenv.mkDerivation (rec {
  version = elk7Version;
  name = "elasticsearch-${optionalString (!enableUnfree) "oss-"}${version}";

  src = fetchurl {
    url = "https://artifacts.elastic.co/downloads/elasticsearch/${name}-${plat}-${arch}.tar.gz";
    sha256 = shas."${stdenv.hostPlatform.system}" or (throw "Unknown architecture");
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

  buildInputs = [ makeWrapper jre_headless utillinux ]
             ++ optional enableUnfree zlib;

  installPhase = ''
    mkdir -p $out
    cp -R bin config lib modules plugins $out

    chmod +x $out/bin/*

    wrapProgram $out/bin/elasticsearch \
      --prefix PATH : "${makeBinPath [ utillinux coreutils gnugrep ]}" \
      --set JAVA_HOME "${jre_headless}"

    wrapProgram $out/bin/elasticsearch-plugin --set JAVA_HOME "${jre_headless}"
  '';

  passthru = { inherit enableUnfree; };

  meta = {
    description = "Open Source, Distributed, RESTful Search Engine";
    license = if enableUnfree then licenses.elastic else licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ apeschar basvandijk ];
  };
} // optionalAttrs enableUnfree {
  dontPatchELF = true;
  nativeBuildInputs = [ autoPatchelfHook ];
  runtimeDependencies = [ zlib ];
  postFixup = ''
    for exe in $(find $out/modules/x-pack-ml/platform/linux-x86_64/bin -executable -type f); do
      echo "patching $exe..."
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$exe"
    done
  '';
})
