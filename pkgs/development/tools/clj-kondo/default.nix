{ stdenv, lib, graalvm11-ce, fetchurl }:

stdenv.mkDerivation rec {
  pname = "clj-kondo";
  version = "2020.12.12";

  reflectionJson = fetchurl {
    name = "reflection.json";
    url = "https://raw.githubusercontent.com/borkdude/${pname}/v${version}/reflection.json";
    sha256 = "ea5c18586fd8803b138a4dd197a0019d5e5a2c76ebe4925b9b54a10125a68c57";
  };

  src = fetchurl {
    url = "https://github.com/borkdude/${pname}/releases/download/v${version}/${pname}-${version}-standalone.jar";
    sha256 = "27b8a82fb613803ab9c712866b7cc89c40fcafc4ac3af178c11b4ed7549934dc";
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
    homepage = "https://github.com/borkdude/clj-kondo";
    license = licenses.epl10;
    platforms = graalvm11-ce.meta.platforms;
    maintainers = with maintainers; [ jlesquembre bandresen ];
  };
}
