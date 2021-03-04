{ lib, stdenv, fetchFromGitHub
, autoPatchelfHook
, fuse, packer
, maven, jdk, jre, makeWrapper, glib, wrapGAppsHook
}:

let
  pname = "cryptomator";
  version = "1.5.13";

  src = fetchFromGitHub {
    owner = "cryptomator";
    repo = "cryptomator";
    rev = version;
    sha256 = "1s9jl3nl6yfjzmilz9b8azk8592nd39xflzfdf38v6s4iiq86r8j";
  };

  icons = fetchFromGitHub {
    owner = "cryptomator";
    repo = "cryptomator-linux";
    rev = version;
    sha256 = "1x6h6wp6yxnj576874xj3d2jm8jmb7918wprqvlz4sryxhlcssa7";
  };

  # perform fake build to make a fixed-output derivation out of the files downloaded from maven central (120MB)
  deps = stdenv.mkDerivation {
    name = "cryptomator-${version}-deps";
    inherit src;

    nativeBuildInputs = [ jdk maven ];

    buildPhase = ''
      cd main
      while mvn -Prelease package -Dmaven.repo.local=$out/.m2 -Dmaven.wagon.rto=5000; [ $? = 1 ]; do
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
    outputHash = "06q8bqdz3c4i84wxl9z5861zwdsw8jzcvsbgxqrnh8rwi7500sa7";
  };

in stdenv.mkDerivation rec {
  inherit pname version src;

  buildPhase = ''
    cd main
    mvn -Prelease package --offline -Dmaven.repo.local=$(cp -dpR ${deps}/.m2 ./ && chmod +w -R .m2 && pwd)/.m2
  '';

  installPhase = ''
    mkdir -p $out/bin/ $out/usr/share/cryptomator/libs/

    cp buildkit/target/libs/* buildkit/target/linux-libs/* $out/usr/share/cryptomator/libs/

    makeWrapper ${jre}/bin/java $out/bin/cryptomator \
      --add-flags "-classpath '$out/usr/share/cryptomator/libs/*'" \
      --add-flags "-Dcryptomator.settingsPath='~/.config/Cryptomator/settings.json'" \
      --add-flags "-Dcryptomator.ipcPortPath='~/.config/Cryptomator/ipcPort.bin'" \
      --add-flags "-Dcryptomator.logDir='~/.local/share/Cryptomator/logs'" \
      --add-flags "-Dcryptomator.mountPointsDir='~/.local/share/Cryptomator/mnt'" \
      --add-flags "-Djdk.gtk.version=3" \
      --add-flags "-Xss20m" \
      --add-flags "-Xmx512m" \
      --add-flags "org.cryptomator.launcher.Cryptomator" \
      --prefix PATH : "$out/usr/share/cryptomator/libs/:${lib.makeBinPath [ jre glib ]}" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ fuse ]}" \
      --set JAVA_HOME "${jre.home}"

    # install desktop entry and icons
    cp -r ${icons}/resources/appimage/AppDir/usr $out/
  '';

  nativeBuildInputs = [ autoPatchelfHook maven makeWrapper wrapGAppsHook jdk ];
  buildInputs = [ fuse packer jre glib ];

  meta = with lib; {
    description = "Free client-side encryption for your cloud files";
    homepage = "https://cryptomator.org";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ bachp ];
    platforms = platforms.linux;
  };
}
