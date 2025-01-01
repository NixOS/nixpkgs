{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  python3,
  qtbase,
  qttools,
  radare2,
  wrapQtAppsHook,
}:

let
  pname = "iaito";
  version = "5.9.6";

  main_src = fetchFromGitHub rec {
    owner = "radareorg";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-rkL7qH1BLXw3eXdCoVuan2C6k05pE5LOIOTbIEtfUbE=";
    name = repo;
  };

  translations_src = fetchFromGitHub rec {
    owner = "radareorg";
    repo = "iaito-translations";
    rev = "e66b3a962a7fc7dfd730764180011ecffbb206bf";
    hash = "sha256-6NRTZ/ydypsB5TwbivvwOH9TEMAff/LH69hCXTvMPp8=";
    name = repo;
  };
in
stdenv.mkDerivation (finalAttrs: {
  inherit pname version;

  srcs = [
    main_src
    translations_src
  ];
  sourceRoot = "${main_src.name}/src";

  postUnpack = ''
    chmod -R u+w ${translations_src.name}
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
    pushd ../../../${translations_src.name}
    make build -j$NIX_BUILD_CORES PREFIX=$out
    popd
  '';

  installPhase = ''
    runHook preInstall

    install -m755 -Dt $out/bin iaito
    install -m644 -Dt $out/share/metainfo ../org.radare.iaito.appdata.xml
    install -m644 -Dt $out/share/applications ../org.radare.iaito.desktop
    install -m644 -Dt $out/share/pixmaps ../img/org.radare.iaito.svg

    pushd ../../../${translations_src.name}
    make install -j$NIX_BUILD_CORES PREFIX=$out
    popd

    runHook postInstall
  '';

  meta = with lib; {
    description = "Official Qt frontend of radare2";
    longDescription = ''
      iaito is the official graphical interface for radare2, a libre reverse
      engineering framework.
    '';
    homepage = "https://radare.org/n/iaito.html";
    changelog = "https://github.com/radareorg/iaito/releases/tag/${finalAttrs.version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ azahi ];
    mainProgram = "iaito";
    platforms = platforms.linux;
  };
})
