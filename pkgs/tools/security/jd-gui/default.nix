{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  jre,
  jdk,
  gradle_6,
  makeDesktopItem,
  copyDesktopItems,
  runtimeShell,
}:

let
  pname = "jd-gui";
  version = "1.6.6";

  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "java-decompiler";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-QHiZPYFwDQzbXVSuhwzQqBRXlkG9QVU+Jl6SKvBoCwQ=";
  };

  gradle = gradle_6;

  desktopItem = makeDesktopItem {
    name = "jd-gui";
    exec = "jd-gui %F";
    icon = "jd-gui";
    comment = "Java Decompiler JD-GUI";
    desktopName = "JD-GUI";
    genericName = "Java Decompiler";
    mimeTypes = [
      "application/java"
      "application/java-vm"
      "application/java-archive"
    ];
    categories = [
      "Development"
      "Debugger"
    ];
    startupWMClass = "org-jd-gui-App";
  };

in
stdenv.mkDerivation rec {
  inherit pname version src;

  patches = [
    # https://github.com/java-decompiler/jd-gui/pull/362
    (fetchpatch {
      name = "nebula-plugin-gradle-6-compatibility.patch";
      url = "https://github.com/java-decompiler/jd-gui/commit/91f805f9dc8ce0097460e63c8095ccea870687e6.patch";
      hash = "sha256-9eaM9Mx2FaKIhGSOHjATKN/CrtvJeXyrH8Mdx8LNtpE=";
    })
  ];

  nativeBuildInputs = [
    jdk
    gradle
    copyDesktopItems
  ];

  mitmCache = gradle.fetchDeps {
    inherit pname;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  gradleBuildTask = "jar";

  installPhase =
    let
      jar = "$out/share/jd-gui/${name}.jar";
    in
    ''
      runHook preInstall

      mkdir -p $out/bin $out/share/{jd-gui,icons/hicolor/128x128/apps}
      cp build/libs/${name}.jar ${jar}
      cp src/linux/resources/jd_icon_128.png $out/share/icons/hicolor/128x128/apps/jd-gui.png

      cat > $out/bin/jd-gui <<EOF
      #!${runtimeShell}
      export JAVA_HOME=${jre}
      exec ${jre}/bin/java -jar ${jar} "\$@"
      EOF
      chmod +x $out/bin/jd-gui

      runHook postInstall
    '';

  desktopItems = [ desktopItem ];

  meta = with lib; {
    description = "Fast Java Decompiler with powerful GUI";
    mainProgram = "jd-gui";
    homepage = "https://java-decompiler.github.io/";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode # deps
    ];
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.thoughtpolice ];
  };
}
