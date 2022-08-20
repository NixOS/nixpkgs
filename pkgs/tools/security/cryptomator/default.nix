{ lib, stdenv, fetchFromGitHub
, autoPatchelfHook
, fuse, jffi
, maven, jdk, jre, makeShellWrapper, glib, wrapGAppsHook
}:

let
  pname = "cryptomator";
  version = "1.6.13";

  src = fetchFromGitHub {
    owner = "cryptomator";
    repo = "cryptomator";
    rev = version;
    sha256 = "sha256-xQxCSWbovdecTFWFDFu2K+lbA6+bSV2l2kk+R/hFcQ0=";
  };

  # perform fake build to make a fixed-output derivation out of the files downloaded from maven central (120MB)
  deps = stdenv.mkDerivation {
    name = "cryptomator-${version}-deps";
    inherit src;

    nativeBuildInputs = [ jdk maven ];
    buildInputs = [ jre ];

    buildPhase = ''
      while mvn -Plinux package -Dmaven.test.skip=true -Dmaven.repo.local=$out/.m2 -Dmaven.wagon.rto=5000; [ $? = 1 ]; do
        echo "timeout, restart maven to continue downloading"
      done
    '';

    # keep only *.{pom,jar,sha1,nbm} and delete all ephemeral files with lastModified timestamps inside
    installPhase = ''
      find $out/.m2 -type f -regex '.+\(\.lastUpdated\|resolver-status\.properties\|_remote\.repositories\)' -delete
      find $out/.m2 -type f -iname '*.pom' -exec sed -i -e 's/\r\+$//' {} \;
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-SFiYHUH1Et7/SgciIvLcQGh54Z3fDVp22jSvDavXPjE=";

    doCheck = false;
  };

in stdenv.mkDerivation rec {
  inherit pname version src;

  buildPhase = ''
    VERSION=${version}
    SEMVER_STR=${version}

    mvn -Plinux package --offline -Dmaven.test.skip=true -Dmaven.repo.local=$(cp -dpR ${deps}/.m2 ./ && chmod +w -R .m2 && pwd)/.m2
  '';


  # This is based on the instructins in https://github.com/cryptomator/cryptomator/blob/develop/dist/linux/appimage/build.sh
  installPhase = ''
    mkdir -p $out/bin/ $out/share/cryptomator/libs/ $out/share/cryptomator/mods/

    cp target/libs/* $out/share/cryptomator/libs/
    cp target/mods/* target/cryptomator-*.jar $out/share/cryptomator/mods/

    # The bundeled jffi.so dosn't work on nixos and causes a segmentation fault
    # we thus replace it with a version build by nixos
    rm $out/share/cryptomator/libs/jff*.jar
    cp -f ${jffi}/share/java/jffi-complete.jar $out/share/cryptomator/libs/

    makeShellWrapper ${jre}/bin/java $out/bin/cryptomator \
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
      --prefix PATH : "$out/share/cryptomator/libs/:${lib.makeBinPath [ jre glib ]}" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ fuse ]}" \
      --set JAVA_HOME "${jre.home}"

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
    maven
    makeShellWrapper
    wrapGAppsHook
    jdk
  ];
  buildInputs = [ fuse jre glib jffi ];

  meta = with lib; {
    description = "Free client-side encryption for your cloud files";
    homepage = "https://cryptomator.org";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode  # deps
    ];
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ bachp ];
    platforms = platforms.linux;
  };
}
