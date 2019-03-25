{ stdenv, fetchurl, makeWrapper, jre, unzip, makeDesktopItem }:

let
  version = "0.9.0";
  name = "jadx-bin-${version}";


  desktopItem = launcher: makeDesktopItem {
    name = "jadx-gui";
    exec = "${launcher} %F";
    comment = "Java Decompiler";
    desktopName = "jadx GUI";
    genericName = "Java and Android Decompiler";
    mimeType = "application/x-java-archive;application/x-java";
    categories = "Development;Debugger;";
  };

  meta = with stdenv.lib; {
    description = "Dex to Java decompiler";
    homepage    = "https://github.com/skylot/jadx";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = [ maintainers.artemist ];
  };

    src = fetchurl {
      url    = "https://github.com/skylot/jadx/archive/v${version}/jadx-${version}.zip";
      sha256 = "00yi5gfnz0zxkc4v405w5b8sg0x4xb2q5cai0v1gz2yzd7q9vx6j";
    };

    nativeBuildInputs = [ unzip makeWrapper ];

    unpackCmd = "unzip -d jadx-${version} $curSrc"; # This would otherwise create multiple directories

  origJadx = stdenv.mkDerivation rec {
    inherit src name version nativeBuildInputs unpackCmd;

    installPhase = ''
      mkdir -p $out/bin $out/lib
      cp lib/*.jar $out/lib
      cp bin/jadx bin/jadx-gui $out/bin
    '';
  };

in stdenv.mkDerivation rec {
  inherit src name version meta nativeBuildInputs unpackCmd;

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper ${origJadx}/bin/jadx-gui $out/bin/jadx-gui \
      --set JAVA_HOME ${jre.home}
    makeWrapper ${origJadx}/bin/jadx $out/bin/jadx \
      --set JAVA_HOME ${jre.home}
  '';
}
