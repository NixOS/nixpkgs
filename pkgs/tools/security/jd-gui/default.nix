{ stdenv, buildGradle, fetchFromGitHub, makeDesktopItem, jre, makeWrapper }:

buildGradle rec {
  pname = "jd-gui";
  version = "1.6.6";

  src = fetchFromGitHub {
    owner = "java-decompiler";
    repo = pname;
    rev = "v${version}";
    sha256 = "010bd3q2m4jy4qz5ahdx86b5f558s068gbjlbpdhq3bhh4yrjy20";
  };

  desktopItem = makeDesktopItem {
    name = "jd-gui";
    exec = "$out/bin/jd-gui %F";
    icon = "jd-gui";
    comment = "Java Decompiler JD-GUI";
    desktopName = "JD-GUI";
    genericName = "Java Decompiler";
    mimeType = "application/java;application/java-vm;application/java-archive";
    categories = "Development;Debugger;";
    extraEntries="StartupWMClass=org-jd-gui-App";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];
  envSpec = ./gradle-env.json;
  gradleFlags = [ "jar" ];

  installPhase = let
    name = "${pname}-${version}";
    jar = "$out/share/jd-gui/${name}.jar";
  in ''
    mkdir -p $out/bin $out/share/{jd-gui,icons/hicolor/128x128/apps}
    cp build/libs/${name}.jar ${jar}
    cp src/linux/resources/jd_icon_128.png $out/share/icons/hicolor/128x128/apps/jd-gui.png
    makeWrapper ${jre}/bin/java $out/bin/jd-gui --add-flags "-jar ${jar}"
    ${desktopItem.buildCommand}
  '';

  meta = with stdenv.lib; {
    description = "Fast Java Decompiler with powerful GUI";
    homepage    = "https://java-decompiler.github.io/";
    license     = licenses.gpl3;
    platforms   = platforms.unix;
    maintainers = [ maintainers.thoughtpolice ];
  };
}
