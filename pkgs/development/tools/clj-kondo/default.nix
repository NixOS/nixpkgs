{ stdenv, lib, graalvm11-ce, fetchurl }:

stdenv.mkDerivation rec {
  pname = "clj-kondo";
  version = "2021.09.25";

  reflectionJson = fetchurl {
    name = "reflection.json";
    url = "https://raw.githubusercontent.com/clj-kondo/${pname}/v${version}/reflection.json";
    sha256 = "sha256-C4QYk5lLienCHKnWXXZPcKmsCTMtIIkXOkvCrZfyIhA=";
  };

  src = fetchurl {
    url = "https://github.com/clj-kondo/${pname}/releases/download/v${version}/${pname}-${version}-standalone.jar";
    sha256 = "sha256-kS6bwsYH/cbjJlIeiDAy6QsAw+D1uHp26d4NBLfStjg=";
  };

  dontUnpack = true;

  buildInputs = [ graalvm11-ce ];

  buildPhase = ''
    native-image  \
      -jar ${src} \
      -H:Name=clj-kondo \
      ${lib.optionalString stdenv.isDarwin ''-H:-CheckToolchain''} \
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
    description = "A linter for Clojure code that sparks joy";
    homepage = "https://github.com/clj-kondo/clj-kondo";
    license = licenses.epl10;
    platforms = graalvm11-ce.meta.platforms;
    maintainers = with maintainers; [ jlesquembre bandresen ];
  };
}
