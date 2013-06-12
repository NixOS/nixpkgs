{ stdenv, fetchurl, writeScript, bash, jre }:

let 

  sbt = writeScript "sbt.sh" ''
    #!${bash}/bin/bash
    ${jre}/bin/java -Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled \
      -XX:MaxPermSize=384M -jar @out@/lib/sbt-launch.jar "$@"
  '';

in stdenv.mkDerivation rec {
  name = "sbt-${version}";

  version = "0.12.3";

  src = fetchurl {
    url = "http://scalasbt.artifactoryonline.com/scalasbt/sbt-native-packages/org/scala-sbt/sbt/${version}/sbt.tgz";
    sha256 = "154ydaxd6ink5sy4flzpyh47nnhgkxwpzmml8q16am7655fpib08";
  };

  installPhase = ''
    mkdir -p $out/lib $out/bin
    mv bin/sbt-launch.jar $out/lib/
    cp ${sbt} $out/bin/sbt
    substituteInPlace $out/bin/sbt --replace @out@ $out
  '';
}
