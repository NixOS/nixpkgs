{
  lib,
  fetchFromGitHub,
  autoPatchelfHook,
  fuse3,
  maven,
  jdk,
  makeShellWrapper,
  glib,
  wrapGAppsHook3,
  libayatana-appindicator,
}:

maven.buildMavenPackage rec {
  pname = "cryptomator";
  version = "1.14.1";

  src = fetchFromGitHub {
    owner = "cryptomator";
    repo = "cryptomator";
    rev = version;
    hash = "sha256-so8RINjFLF9H4K9f/60Ym/v/VpcVfxJ/c+JDOAPFgZU=";
  };

  mvnJdk = jdk;
  mvnParameters = "-Dmaven.test.skip=true -Plinux";
  mvnHash = "sha256-aB7wgnJAYvCizC0/gG/amcId/WVVWmZndItm398nDfQ=";

  preBuild = ''
    VERSION=${version}
    SEMVER_STR=${version}
  '';

  # This is based on the instructins in https://github.com/cryptomator/cryptomator/blob/develop/dist/linux/appimage/build.sh
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin/ $out/share/cryptomator/libs/ $out/share/cryptomator/mods/

    cp target/libs/* $out/share/cryptomator/libs/
    cp target/mods/* target/cryptomator-*.jar $out/share/cryptomator/mods/

    makeShellWrapper ${jdk}/bin/java $out/bin/${pname} \
      --add-flags "--enable-preview" \
      --add-flags "--enable-native-access=org.cryptomator.jfuse.linux.amd64,org.purejava.appindicator" \
      --add-flags "--class-path '$out/share/cryptomator/libs/*'" \
      --add-flags "--module-path '$out/share/cryptomator/mods'" \
      --add-flags "-Dfile.encoding='utf-8'" \
      --add-flags "-Dcryptomator.logDir='@{userhome}/.local/share/Cryptomator/logs'" \
      --add-flags "-Dcryptomator.pluginDir='@{userhome}/.local/share/Cryptomator/plugins'" \
      --add-flags "-Dcryptomator.settingsPath='@{userhome}/.config/Cryptomator/settings.json'" \
      --add-flags "-Dcryptomator.p12Path='@{userhome}/.config/Cryptomator/key.p12'" \
      --add-flags "-Dcryptomator.ipcSocketPath='@{userhome}/.config/Cryptomator/ipc.socket'" \
      --add-flags "-Dcryptomator.mountPointsDir='@{userhome}/.local/share/Cryptomator/mnt'" \
      --add-flags "-Dcryptomator.showTrayIcon=true" \
      --add-flags "-Dcryptomator.buildNumber='nix-${src.rev}'" \
      --add-flags "-Dcryptomator.appVersion='${version}'" \
      --add-flags "-Djava.net.useSystemProxies=true" \
      --add-flags "-Xss20m" \
      --add-flags "-Xmx512m" \
      --add-flags "-Dcryptomator.disableUpdateCheck=true" \
      --add-flags "-Dcryptomator.integrationsLinux.trayIconsDir='$out/share/icons/hicolor/symbolic/apps'" \
      --add-flags "--module org.cryptomator.desktop/org.cryptomator.launcher.Cryptomator" \
      --prefix PATH : "$out/share/cryptomator/libs/:${
        lib.makeBinPath [
          jdk
          glib
        ]
      }" \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          fuse3
          libayatana-appindicator
        ]
      }" \
      --set JAVA_HOME "${jdk.home}"

    # install desktop entry and icons
    cp -r ${src}/dist/linux/appimage/resources/AppDir/usr/* $out/
    # The directory is read only when copied, enable read to install additional files
    chmod +w -R $out/
    cp ${src}/dist/linux/common/org.cryptomator.Cryptomator256.png $out/share/icons/hicolor/256x256/apps/org.cryptomator.Cryptomator.png
    cp ${src}/dist/linux/common/org.cryptomator.Cryptomator512.png $out/share/icons/hicolor/512x512/apps/org.cryptomator.Cryptomator.png
    cp ${src}/dist/linux/common/org.cryptomator.Cryptomator.svg $out/share/icons/hicolor/scalable/apps/org.cryptomator.Cryptomator.svg
    cp ${src}/dist/linux/common/org.cryptomator.Cryptomator.tray-unlocked.svg $out/share/icons/hicolor/scalable/apps/org.cryptomator.Cryptomator.tray-unlocked.svg
    cp ${src}/dist/linux/common/org.cryptomator.Cryptomator.tray.svg $out/share/icons/hicolor/scalable/apps/org.cryptomator.Cryptomator.tray.svg
    cp ${src}/dist/linux/common/org.cryptomator.Cryptomator.tray-unlocked.svg $out/share/icons/hicolor/symbolic/apps/org.cryptomator.Cryptomator.tray-unlocked-symbolic.svg
    cp ${src}/dist/linux/common/org.cryptomator.Cryptomator.tray.svg $out/share/icons/hicolor/symbolic/apps/org.cryptomator.Cryptomator.tray-symbolic.svg
    cp ${src}/dist/linux/common/org.cryptomator.Cryptomator.desktop $out/share/applications/org.cryptomator.Cryptomator.desktop
    cp ${src}/dist/linux/common/org.cryptomator.Cryptomator.metainfo.xml $out/share/metainfo/org.cryptomator.Cryptomator.metainfo.xml
    cp ${src}/dist/linux/common/application-vnd.cryptomator.vault.xml $out/share/mime/packages/application-vnd.cryptomator.vault.xml

    runHook postInstall
  '';

  nativeBuildInputs = [
    autoPatchelfHook
    makeShellWrapper
    wrapGAppsHook3
    jdk
  ];
  buildInputs = [
    fuse3
    jdk
    glib
    libayatana-appindicator
  ];

  meta = with lib; {
    description = "Free client-side encryption for your cloud files";
    mainProgram = "cryptomator";
    homepage = "https://cryptomator.org";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode # deps
    ];
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ bachp ];
    platforms = [ "x86_64-linux" ];
    # Uses abandoned JEP 430 string template preview, removed in JDK 23
    broken = true;
  };
}
