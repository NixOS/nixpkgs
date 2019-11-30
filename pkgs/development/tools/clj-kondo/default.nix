{ stdenv, lib, graalvm8, fetchurl }:

stdenv.mkDerivation rec{
  pname = "clj-kondo";
  version = "2019.11.07";

  reflectionJson = fetchurl {
    name = "reflection.json";
    url = "https://raw.githubusercontent.com/borkdude/${pname}/v${version}/reflection.json";
    sha256 = "1m6kja38p6aypawbynkyq8bdh8wpdjmyqrhslinqid9r8cl25rcq";
  };

  src = fetchurl {
    url = "https://github.com/borkdude/${pname}/releases/download/v${version}/${pname}-${version}-standalone.jar";
    sha256 = "145cdpcdzh2v77kvg8a0qqac9ra7vdcf9hj71vy5w7fck08yf192";
  };

  dontUnpack = true;

  buildInputs = [ graalvm8 ];

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
    homepage = https://github.com/borkdude/clj-kondo;
    license = licenses.epl10;
    platforms = graalvm8.meta.platforms;
    maintainers = with maintainers; [ jlesquembre bandresen ];
  };
}
