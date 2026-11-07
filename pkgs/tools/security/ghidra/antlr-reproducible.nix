{
  stdenvNoCC,
  fetchurl,
  openjdk,
}:

let
  antlrJar = fetchurl {
    url = "https://repo1.maven.org/maven2/org/antlr/antlr/3.5.2/antlr-3.5.2.jar";
    hash = "sha256-WsNsKs+woPPTfa/iC1tXDyZD4tAAxkjURQPCc4vmQ98=";
  };

  antlrSources = fetchurl {
    url = "https://repo1.maven.org/maven2/org/antlr/antlr/3.5.2/antlr-3.5.2-sources.jar";
    hash = "sha256-4o3u9At0BAH31wdd4k/5VFG916m6zj6YoTib/YoVTTQ=";
  };

  antlrRuntime = fetchurl {
    url = "https://repo1.maven.org/maven2/org/antlr/antlr-runtime/3.5.2/antlr-runtime-3.5.2.jar";
    hash = "sha256-zj/I7LEPOemjzdy7LONQ0nLZzT0LHhjm/nPDuTichzQ=";
  };

  st4 = fetchurl {
    url = "https://repo1.maven.org/maven2/org/antlr/ST4/4.0.8/ST4-4.0.8.jar";
    hash = "sha256-WMqrxAyfdLC1mT/YaOD2SlDAdZCU5qJRqq+tmO38ejs=";
  };
in
stdenvNoCC.mkDerivation {
  pname = "antlr-3.5.2-reproducible";
  version = "3.5.2";

  dontUnpack = true;

  nativeBuildInputs = [
    openjdk
  ];

  # ANTLR 3.5.2 embeds timestamps and iterates unordered sets in code generation.
  # Patch only the three affected classes; keep the rest of the JAR upstream.
  buildPhase = ''
    runHook preBuild

    mkdir -p source classes

    (
      cd source
      ${openjdk}/bin/jar xf ${antlrSources}
    )

    substituteInPlace source/org/antlr/Tool.java \
      --replace-fail \
      '        return new StringBuffer().append(sy).append("-").append(sm).append("-").append(sd).append(" ").append(sh).append(":").append(smin).append(":").append(ssec).toString();' \
      '        return "1980-01-01 00:00:00";'

    substituteInPlace source/org/antlr/tool/CompositeGrammar.java \
      --replace-fail \
      'Set<Rule> rules = new HashSet<Rule>();' \
      'Set<Rule> rules = new java.util.LinkedHashSet<Rule>();'

    substituteInPlace source/org/antlr/grammar/v3/DefineGrammarItemsWalker.java \
      --replace-fail \
      'currentRewriteRule.rewriteRefsDeep = new HashSet<GrammarAST>();' \
      'currentRewriteRule.rewriteRefsDeep = new java.util.LinkedHashSet<GrammarAST>();' \
      --replace-fail \
      'currentRewriteBlock.rewriteRefsShallow = new HashSet<GrammarAST>();' \
      'currentRewriteBlock.rewriteRefsShallow = new java.util.LinkedHashSet<GrammarAST>();' \
      --replace-fail \
      'currentRewriteBlock.rewriteRefsDeep = new HashSet<GrammarAST>();' \
      'currentRewriteBlock.rewriteRefsDeep = new java.util.LinkedHashSet<GrammarAST>();'

    ${openjdk}/bin/javac \
      --release 8 \
      -cp "${antlrJar}:${antlrRuntime}:${st4}" \
      -d classes \
      source/org/antlr/Tool.java \
      source/org/antlr/tool/CompositeGrammar.java \
      source/org/antlr/grammar/v3/DefineGrammarItemsWalker.java

    install -m 0644 ${antlrJar} antlr-3.5.2.jar

    for cls in \
      org/antlr/Tool.class \
      org/antlr/tool/CompositeGrammar.class \
      org/antlr/grammar/v3/DefineGrammarItemsWalker.class; do
      ${openjdk}/bin/jar \
        --update \
        --file antlr-3.5.2.jar \
        --date 1980-01-01T00:00:02Z \
        -C classes "$cls"
    done

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 antlr-3.5.2.jar "$out/share/java/antlr-3.5.2.jar"

    runHook postInstall
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    mkdir check
    (
      cd check
      printf '%s\n' 'grammar T;' "r : 'a' ;" > T.g
      ${openjdk}/bin/java \
        -cp "$out/share/java/antlr-3.5.2.jar:${antlrRuntime}:${st4}" \
        org.antlr.Tool T.g
      grep -q '1980-01-01 00:00:00' TParser.java
    )

    runHook postInstallCheck
  '';
}
