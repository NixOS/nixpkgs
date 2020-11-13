{ stdenv, lib, graalvm11-ce, fetchurl }:

stdenv.mkDerivation rec {
  pname = "clj-kondo";
  version = "2020.11.07";

  reflectionJson = fetchurl {
    name = "reflection.json";
    url = "https://raw.githubusercontent.com/borkdude/${pname}/v${version}/reflection.json";
    sha256 = "0mwclqjh38alkddr5r7bfqn5lplx06h9gladi89kp06qdxc1hp7a";
  };

  src = fetchurl {
    url = "https://github.com/borkdude/${pname}/releases/download/v${version}/${pname}-${version}-standalone.jar";
    sha256 = "1xqryfcn82bp8wasqnllfgvhl5w9zm63yw8c2kgxz18dayhq4i31";
  };

  dontUnpack = true;

  buildInputs = [ graalvm11-ce ];

  buildPhase = ''
    native-image  \
      -jar ${src} \
      -H:Name=clj-kondo \
      -H:+ReportExceptionStackTraces \
      -J-Dclojure.spec.skip-macros=true \
      -J-Dclojure.compiler.direct-linking=true \
      "-H:IncludeResources=clj_kondo/impl/cache/built_in/.*" \
      -H:ReflectionConfigurationFiles=${reflectionJson} \
      --initialize-at-build-time  \
      -H:Log=registerResource: \
      --verbose \
      --no-fallback \
      --no-server \
      "-J-Xmx3g"
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp clj-kondo $out/bin/clj-kondo
  '';

  meta = with lib; {
    description = "A linter for Clojure code that sparks joy.";
    homepage = "https://github.com/borkdude/clj-kondo";
    license = licenses.epl10;
    platforms = graalvm11-ce.meta.platforms;
    maintainers = with maintainers; [ jlesquembre bandresen ];
  };
}
