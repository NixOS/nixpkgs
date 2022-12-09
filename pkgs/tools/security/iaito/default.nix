{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, python3
, qtbase
, qttools
, radare2
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "iaito";
  version = "5.7.8";

  srcs = [
    (fetchFromGitHub rec {
      owner = "radareorg";
      repo = "iaito";
      rev = version;
      hash = "sha256-c36WLpVUnffeY6cXSEHvguo8BHyxaLAluN9hBKsQc0s=";
      name = repo;
    })
    (fetchFromGitHub rec {
      owner = "radareorg";
      repo = "iaito-translations";
      rev = "ab923335409fa298c39f0014588d78d926c6f3a2";
      hash = "sha256-qkIC67a6YRwOa2Sr16Vg6If1TmAiSKUV7hw13Wxwl/w=";
      name = repo;
    })
  ];
  sourceRoot = "iaito/src";

  postUnpack = ''
    chmod -R u+w iaito-translations
  '';

  postPatch = ''
    substituteInPlace common/ResourcePaths.cpp \
      --replace "/app/share/iaito/translations" "$out/share/iaito/translations"
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    radare2
  ];

  postBuild = ''
    pushd ../../../iaito-translations
    make build PREFIX=$out
    popd
  '';

  installPhase = ''
    runHook preInstall

    install -m755 -Dt $out/bin iaito
    install -m644 -Dt $out/share/metainfo ../org.radare.iaito.appdata.xml
    install -m644 -Dt $out/share/applications ../org.radare.iaito.desktop
    install -m644 -Dt $out/share/pixmaps ../img/iaito-o.svg

    pushd ../../../iaito-translations
    make install PREFIX=$out -j$NIX_BUILD_CORES
    popd

    runHook postInstall
  '';

  meta = with lib; {
    description = "An official graphical interface of radare2";
    longDescription = ''
      iaito is the official graphical interface of radare2. It's the
      continuation of Cutter for radare2 after the Rizin fork.
    '';
    homepage = "https://radare.org/n/iaito.html";
    changelog = "https://github.com/radareorg/iaito/releases/tag/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ azahi ];
    platforms = platforms.linux;
  };
}
