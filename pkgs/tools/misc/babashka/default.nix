{ stdenv, fetchurl, graalvm8 } :

stdenv.mkDerivation rec {
  pname = "babashka";
  version = "0.0.71";

  src = fetchurl {
    url = "https://github.com/borkdude/babashka/releases/download/v${version}/babashka-${version}-standalone.jar";
    sha256 = "0gyahrxrvyfkvqg4dhzx81mg2hw56ji3aa1yxb9ycwa5bawb6080";
  };

  reflectionJson = fetchurl {
    url = "https://github.com/borkdude/babashka/releases/download/v${version}/reflection.json";
    sha256 = "13p1yw27sjvfi130pw7m9c1yzdgh7wxh8r6z8b4qmr3iifidfrcr";
  };

  dontUnpack = true;

  buildInputs = [ graalvm8 ];

  buildPhase = ''
    native-image \
      -jar ${src} \
      -H:Name=bb \
      -H:+ReportExceptionStackTraces \
      -J-Dclojure.spec.skip-macros=true \
      -J-Dclojure.compiler.direct-linking=true \
      "-H:IncludeResources=BABASHKA_VERSION" \
      "-H:IncludeResources=SCI_VERSION" \
      -H:ReflectionConfigurationFiles=${reflectionJson} \
      --initialize-at-run-time=java.lang.Math\$RandomNumberGeneratorHolder \
      --initialize-at-build-time \
      -H:Log=registerResource: \
      -H:EnableURLProtocols=http,https \
      --enable-all-security-services \
      -H:+JNI \
      --verbose \
      --no-fallback \
      --no-server \
      -J-Xmx3g
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bb $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Tool for executing Clojure snippets or scripts in the same space where you would use Bash";
    homepage = "https://github.com/borkdude/babashka/";
    license = licenses.epl10;
    platforms = graalvm8.meta.platforms;
    maintainers = with maintainers; [ DerGuteMoritz ];
  };
}
