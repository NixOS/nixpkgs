{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle,
  jdk,
  quark-engine,
  makeBinaryWrapper,
  imagemagick,
  makeDesktopItem,
  copyDesktopItems,
  desktopToDarwinBundle,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jadx";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "skylot";
    repo = "jadx";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+F+PHAd1+FmdAlQkjYDBsUYCUzKXG19ZUEorfvBUEg0=";
  };

  patches = [
    # Remove use of launch4j - contains platform binaries not able to be cached by mitmCache
    ./no-native-deps.diff
  ];

  nativeBuildInputs = [
    gradle
    jdk
    imagemagick
    makeBinaryWrapper
    copyDesktopItems
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ desktopToDarwinBundle ];

  # Otherwise, Gradle fails with `java.net.SocketException: Operation not permitted`
  __darwinAllowLocalNetworking = true;

  mitmCache = gradle.fetchDeps {
    pname = "jadx";
    data = ./deps.json;
  };

  preBuild = "export JADX_VERSION=${finalAttrs.version}";

  gradleBuildTask = "pack";

  installPhase = ''
    runHook preInstall

    mkdir $out $out/bin
    cp -R build/jadx/lib $out
    for prog in jadx jadx-gui; do
      cp build/jadx/bin/$prog $out/bin
      wrapProgram $out/bin/$prog \
        --set JAVA_HOME ${jdk.home} \
        --prefix PATH : "${lib.makeBinPath [ quark-engine ]}"
    done

    for size in 16 32 48; do
      install -Dm444 \
        jadx-gui/src/main/resources/logos/jadx-logo-"$size"px.png \
        $out/share/icons/hicolor/"$size"x"$size"/apps/jadx.png
    done
    for size in 64 128 256; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      convert -resize "$size"x"$size" jadx-gui/src/main/resources/logos/jadx-logo.png $out/share/icons/hicolor/"$size"x"$size"/apps/jadx.png
    done

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "jadx";
      desktopName = "JADX";
      exec = "jadx-gui";
      icon = "jadx";
      comment = finalAttrs.meta.description;
      categories = [
        "Development"
        "Utility"
      ];
    })
  ];

  meta = with lib; {
    changelog = "https://github.com/skylot/jadx/releases/tag/v${finalAttrs.version}";
    description = "Dex to Java decompiler";
    homepage = "https://github.com/skylot/jadx";
    longDescription = ''
      Command line and GUI tools for produce Java source code from Android Dex
      and Apk files.
    '';
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode # deps
    ];
    license = licenses.asl20;
    platforms = platforms.unix;
    mainProgram = "jadx-gui";
    maintainers = with maintainers; [ emilytrau ];
  };
})
