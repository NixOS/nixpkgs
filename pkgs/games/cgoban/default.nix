{ lib
, stdenv
, writers
, adoptopenjdk-jre-bin
, fetchurl
, makeWrapper
}:
stdenv.mkDerivation rec {
  pname = "cgoban";
  version = "3.5.23";

  nativeBuildInputs = [ adoptopenjdk-jre-bin makeWrapper ];

  src = fetchurl {
    url = "https://web.archive.org/web/20210116034119/https://files.gokgs.com/javaBin/cgoban.jar";
    sha256 = "0srw1hqr9prgr9dagfbh2j6p9ivaj40kdpyhs6zjkg7lhnnrrrcv";
  };

  dontConfigure = true;
  dontUnpack = true;
  dontBuild = true;
  dontPatchELF = true;

  installPhase = ''
    runHook preInstall
    install -D $src $out/lib/cgoban.jar
    makeWrapper ${adoptopenjdk-jre-bin}/bin/java $out/bin/cgoban --add-flags "-jar $out/lib/cgoban.jar"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Client for the KGS Go Server";
    homepage = "https://www.gokgs.com/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.free;
    maintainers = with maintainers; [ savannidgerinel ];
    platforms = adoptopenjdk-jre-bin.meta.platforms;
  };
}
