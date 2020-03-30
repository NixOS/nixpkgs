{ stdenv, fetchurl, lib, graalvm8 }:
with stdenv.lib;
stdenv.mkDerivation rec{
  pname = "babashka";
  version = "0.0.78";

  reflectionJson = fetchurl {
    name = "reflection.json";
    url = "https://github.com/borkdude/${pname}/releases/download/v${version}/${pname}-${version}-reflection.json";
    sha256 = "1m1nwdxjsc6bkdzkbsll316ly0c3qxaimjzyfph1220irjxnm7xf";
  };

  src = fetchurl {
    url = "https://github.com/borkdude/${pname}/releases/download/v${version}/${pname}-${version}-standalone.jar";
    sha256 = "01w990zk5qjrbnc846snh6na002kdyrlrfnqwg03ibx20g3mr7if";
  };

  dontUnpack = true;

  buildInputs = [ graalvm8 ];

  buildPhase = ''
    native-image  \
      -jar ${src} \
      -H:Name=bb \
      -H:+ReportExceptionStackTraces \
      -J-Dclojure.spec.skip-macros=true \
      -J-Dclojure.compiler.direct-linking=true \
      "-H:IncludeResources=${version}-SNAPSHOT" \
      "-H:IncludeResources=SCI_VERSION" \
      -H:ReflectionConfigurationFiles=${reflectionJson} \
      --initialize-at-run-time=java.lang.Math\$RandomNumberGeneratorHolder \
      --initialize-at-build-time  \
      -H:Log=registerResource: \
      -H:EnableURLProtocols=http,https \
      --enable-all-security-services \
      -H:+JNI \
      --verbose \
      --no-fallback \
      --no-server \
      --report-unsupported-elements-at-runtime \
      "-J-Xmx3g"
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bb $out/bin/bb
  '';

  meta = {
    description = "A Clojure babushka for the grey areas of Bash";
    homepage = https://github.com/borkdude/babashka;
    license = licenses.epl10;
    platforms = graalvm8.meta.platforms;
    maintainers = with maintainers; [ bhougland jlesquembre ];
  };
}
