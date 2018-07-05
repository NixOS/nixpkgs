{ wrapCommand, fetchurl, jre, buildTools, lib }:

let
  jar = fetchurl {
    urls = [
      "https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_${version}.jar"
      "https://github.com/iBotPeaches/Apktool/releases/download/v${version}/apktool_${version}.jar"
    ];
    sha256 = "1wjpn1wxg8fid2mch5ili35xqvasa3pk8h1xaiygw5idpxh3cm0f";
  };
  version = "2.3.3";
in wrapCommand "apktool" {
  inherit version;
  executable = "${jre}/bin/java";
  makeWrapperArgs = ["--add-flags -jar" "--add-flags ${jar}"
                     "--prefix PATH : ${buildTools}/build-tools/25.0.1"];
  meta = with lib; {
    description = "A tool for reverse engineering Android apk files";
    homepage    = https://ibotpeaches.github.io/Apktool/;
    license     = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms   = with platforms; unix;
  };

}
