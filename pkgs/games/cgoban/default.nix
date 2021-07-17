{ lib
, stdenv
, writers
, fetchurl
, adoptopenjdk-jre-bin
, ver ? "3.5.23"
, hash ? "0srw1hqr9prgr9dagfbh2j6p9ivaj40kdpyhs6zjkg7lhnnrrrcv" }:
let
  cgoban_jar = stdenv.mkDerivation rec {
    pname = "cgoban_jar";
    version = ver;

    src = fetchurl {
      url = "http://files.gokgs.com/javaBin/cgoban.jar";
      hash = "sha256:${hash}";
    };

    dontConfigure = true;
    dontUnpack = true;
    dontBuild = true;
    dontPatchELF = true;

    installPhase = ''
      mkdir -p $out/lib
      cp ${src} $out/lib/cgoban.jar
    '';
  };
  cgoban_sh = writers.writeBash "cgoban" "${adoptopenjdk-jre-bin}/bin/java -jar ${cgoban_jar}/lib/cgoban.jar";

in stdenv.mkDerivation {
  pname = "cgoban";
  version = ver;

  src = ./.;

  installPhase = ''
    mkdir -p $out/bin
    cp ${cgoban_sh} $out/bin/cgoban
  '';

  meta = with lib; {
    description = "Client for the KGS Go Server";
    homepage = "https://www.gokgs.com/";
    license = licenses.free;
    maintainers = with maintainers; [ savannidgerinel ];
    platforms = adoptopenjdk-jre-bin.meta.platforms;
  };
}
