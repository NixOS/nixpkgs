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

let
  pname = "iaito";
  version = "5.9.0";

  main_src = fetchFromGitHub rec {
    owner = "radareorg";
    repo = pname;
    rev = version;
    hash = "sha256-Ep3Cbi0qjY4PKG0urr12y0DgX/l/Tsq8w1qlyH0lu3s=";
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

stdenv.mkDerivation rec {
  inherit pname version;

  srcs = [ main_src translations_src ];
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

  # the radare2 binary package seems to not install all necessary headers.
  env.NIX_CFLAGS_COMPILE = toString [ "-I" "${radare2.src}/shlr/sdb/include/sdb" ];

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
    description = "An official graphical interface of radare2";
    mainProgram = "iaito";
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
