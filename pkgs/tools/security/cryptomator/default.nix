{ lib
, stdenv
, fetchFromGitHub
, autoPatchelfHook
, fuse
, packer
, maven3
, zulu17
, makeWrapper
, glib
, wrapGAppsHook
}:

let
  pname = "cryptomator";
  version = "1.6.4";

  src = fetchFromGitHub {
    owner = "cryptomator";
    repo = "cryptomator";
    rev = version;
    sha256 = "15pp4fg8q2b9p9zcqqb8lfp3hr5170yj3md5qc9i3lx0dn58qd2i";
  };

  # perform fake build to make a fixed-output derivation out of the files downloaded from maven central (120MB)
  deps = stdenv.mkDerivation {
    name = "cryptomator-${version}-deps";
    inherit src;

    nativeBuildInputs = [ zulu17 maven3 ];

    preConfigure = ''
      sed '/isKeyLocked/c\//removed temporarily (do we have old OpenJFX on Nix?)' -i  src/main/java/org/cryptomator/ui/controls/SecurePasswordField.java
    '';

    buildPhase = ''
      mvn -Plinux package -Dmaven.repo.local=$out/.m2
    '';

    # keep only *.{pom,jar,sha1,nbm} and delete all ephemeral files with lastModified timestamps inside
    installPhase = ''
      find $out/.m2 -type f -regex '.+\(\.lastUpdated\|resolver-status\.properties\|_remote\.repositories\)' -delete
      find $out/.m2 -type f -iname '*.pom' -exec sed -i -e 's/\r\+$//' {} \;
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "0qp9z2di31dx24s62kb8py93payjbifs4j7727myvz9pss4vv2j2";
  };

in
stdenv.mkDerivation rec {
  inherit pname version src;

  buildPhase = ''
    mvn -Plinux package --offline -Dmaven.repo.local=${deps}/.m2
  '';
  installPhase = ''
    mkdir -p $out/bin $out/libs $out/mods
    # moving over all libs
    cp -r target/mods/* $out/mods
    cp target/cryptomator-1.6.4.jar $out/mods
    cp -r target/libs/* $out/libs

    makeWrapper ${zulu17}/bin/java $out/bin/cryptomator \
      --add-flags "-p '$out/mods'" \
      --add-flags "-classpath '$out/libs/*'" \
      --add-flags "-Dcryptomator.settingsPath='~/.config/Cryptomator/settings.json'" \
      --add-flags "-Dcryptomator.ipcSocketPath='~/.config/Cryptomator/ipc.socket'" \
      --add-flags "-Dcryptomator.logDir='~/.local/share/Cryptomator/logs'" \
      --add-flags "-Dcryptomator.mountPointsDir='~/.local/share/Cryptomator/mnt'" \
      --add-flags "-Djdk.gtk.version=3" \
      --add-flags "-Xss20m" \
      --add-flags "-Xmx512m" \
      --add-flags "-m org.cryptomator.desktop/org.cryptomator.launcher.Cryptomator" \
      --prefix PATH : "$out/usr/share/cryptomator/libs/:${lib.makeBinPath [ zulu17 glib ]}" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ fuse ]}" \
      --set JAVA_HOME "${zulu17.home}"

    # install desktop entry and icons
    cp -r ${src}/dist/linux/appimage/resources/AppDir/usr/* $out/
  '';

  nativeBuildInputs = [ autoPatchelfHook maven3 makeWrapper wrapGAppsHook zulu17 ];
  buildInputs = [ fuse packer zulu17 glib ];

  meta = with lib; {
    description = "Free client-side encryption for your cloud files";
    homepage = "https://cryptomator.org";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ bachp peterwilli ];
    platforms = platforms.linux;
  };
}
