{ lib, stdenv, fetchFromGitHub
, autoPatchelfHook
, fuse3
, maven, jdk, makeShellWrapper, glib, wrapGAppsHook
}:


let
  mavenJdk = maven.override {
    jdk = jdk;
  };
in
assert stdenv.isLinux; # better than `called with unexpected argument 'enableJavaFX'`
mavenJdk.buildMavenPackage rec {
  pname = "cryptomator";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "cryptomator";
    repo = "cryptomator";
    rev = version;
    hash = "sha256-xhj7RUurBRq9ZIDAlcq7KyYGnLqc+vTjaf2VMNStpVQ";
  };

  mvnParameters = "-Dmaven.test.skip=true";
  mvnHash = "sha256-XAIwKn8wMqILMQbg9wM4kHAaRSGWQaBx9AXQyJuUO5k=";

  preBuild = ''
    VERSION=${version}
    SEMVER_STR=${version}
  '';


  # This is based on the instructins in https://github.com/cryptomator/cryptomator/blob/develop/dist/linux/appimage/build.sh
  installPhase = ''
    mkdir -p $out/bin/ $out/share/cryptomator/libs/ $out/share/cryptomator/mods/

    cp target/libs/* $out/share/cryptomator/libs/
    cp target/mods/* target/cryptomator-*.jar $out/share/cryptomator/mods/

    makeShellWrapper ${jdk}/bin/java $out/bin/cryptomator \
      --add-flags "--enable-preview" \
      --add-flags "--class-path '$out/share/cryptomator/libs/*'" \
      --add-flags "--module-path '$out/share/cryptomator/mods'" \
      --add-flags "-Dcryptomator.logDir='~/.local/share/Cryptomator/logs'" \
      --add-flags "-Dcryptomator.pluginDir='~/.local/share/Cryptomator/plugins'" \
      --add-flags "-Dcryptomator.settingsPath='~/.config/Cryptomator/settings.json'" \
      --add-flags "-Dcryptomator.ipcSocketPath='~/.config/Cryptomator/ipc.socket'" \
      --add-flags "-Dcryptomator.mountPointsDir='~/.local/share/Cryptomator/mnt'" \
      --add-flags "-Dcryptomator.showTrayIcon=false" \
      --add-flags "-Dcryptomator.buildNumber='nix'" \
      --add-flags "-Dcryptomator.appVersion='${version}'" \
      --add-flags "-Djdk.gtk.version=3" \
      --add-flags "-Xss20m" \
      --add-flags "-Xmx512m" \
      --add-flags "-Djavafx.embed.singleThread=true " \
      --add-flags "-Dawt.useSystemAAFontSettings=on" \
      --add-flags "--module org.cryptomator.desktop/org.cryptomator.launcher.Cryptomator" \
      --prefix PATH : "$out/share/cryptomator/libs/:${lib.makeBinPath [ jdk glib ]}" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ fuse3 ]}" \
      --set JAVA_HOME "${jdk.home}"

    # install desktop entry and icons
    cp -r ${src}/dist/linux/appimage/resources/AppDir/usr/* $out/
    # The directory is read only when copied, enable read to install additional files
    chmod +w -R $out/
    cp ${src}/dist/linux/common/org.cryptomator.Cryptomator256.png $out/share/icons/hicolor/256x256/apps/org.cryptomator.Cryptomator.png
    cp ${src}/dist/linux/common/org.cryptomator.Cryptomator512.png $out/share/icons/hicolor/512x512/apps/org.cryptomator.Cryptomator.png
    cp ${src}/dist/linux/common/org.cryptomator.Cryptomator.svg $out/share/icons/hicolor/scalable/apps/org.cryptomator.Cryptomator.svg
    cp ${src}/dist/linux/common/org.cryptomator.Cryptomator.desktop $out/share/applications/org.cryptomator.Cryptomator.desktop
    cp ${src}/dist/linux/common/org.cryptomator.Cryptomator.metainfo.xml $out/share/metainfo/org.cryptomator.Cryptomator.metainfo.xml
    cp ${src}/dist/linux/common/application-vnd.cryptomator.vault.xml $out/share/mime/packages/application-vnd.cryptomator.vault.xml
  '';

  nativeBuildInputs = [
    autoPatchelfHook
    makeShellWrapper
    wrapGAppsHook
    jdk
  ];
  buildInputs = [ fuse3 jdk glib ];

  meta = with lib; {
    description = "Free client-side encryption for your cloud files";
    homepage = "https://cryptomator.org";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode  # deps
    ];
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ bachp ];
    platforms = [ "x86_64-linux" ];
  };
}
