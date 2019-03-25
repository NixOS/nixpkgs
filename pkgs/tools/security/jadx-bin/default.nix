{ stdenv, fetchurl, makeWrapper, jre, unzip, makeDesktopItem }:

stdenv.mkDerivation rec {
  version = "0.9.0";
  name = "jadx-bin-${version}";

  desktopItem = makeDesktopItem {
    name = "jadx-gui";
    exec = "jadx-gui %F";
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


  installPhase = ''
    mkdir -p $out/bin $out/lib
    cp lib/*.jar $out/lib
    cp bin/jadx bin/jadx-gui $out/bin
    wrapProgram $out/bin/jadx-gui --set JAVA_HOME ${jre.home}
    wrapProgram $out/bin/jadx --set JAVA_HOME ${jre.home}
    install -Dm644 "${desktopItem}/share/applications/"* -t "$out/share/applications/"
  '';
}
