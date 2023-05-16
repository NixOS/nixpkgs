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

<<<<<<< HEAD
let
  pname = "iaito";
  version = "5.8.8";

  main_src = fetchFromGitHub rec {
    owner = "radareorg";
    repo = pname;
    rev = version;
    hash = "sha256-/sXdp6QpDxltesg5i2CD0K2r18CrbGZmmI7HqULvFfA=";
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
=======
stdenv.mkDerivation rec {
  pname = "iaito";
  version = "5.8.4";

  srcs = [
    (fetchFromGitHub rec {
      owner = "radareorg";
      repo = "iaito";
      rev = version;
      hash = "sha256-pt2vq+JN+Ccv+9o8s2y87xTVeQp2WJ0UfKdoWGsBkUI=";
      name = repo;
    })
    (fetchFromGitHub rec {
      owner = "radareorg";
      repo = "iaito-translations";
      rev = "e66b3a962a7fc7dfd730764180011ecffbb206bf";
      hash = "sha256-6NRTZ/ydypsB5TwbivvwOH9TEMAff/LH69hCXTvMPp8=";
      name = repo;
    })
  ];
  sourceRoot = "iaito/src";

  postUnpack = ''
    chmod -R u+w iaito-translations
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    pushd ../../../${translations_src.name}
=======
    pushd ../../../iaito-translations
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    make build -j$NIX_BUILD_CORES PREFIX=$out
    popd
  '';

  installPhase = ''
    runHook preInstall

    install -m755 -Dt $out/bin iaito
    install -m644 -Dt $out/share/metainfo ../org.radare.iaito.appdata.xml
    install -m644 -Dt $out/share/applications ../org.radare.iaito.desktop
    install -m644 -Dt $out/share/pixmaps ../img/iaito-o.svg

<<<<<<< HEAD
    pushd ../../../${translations_src.name}
=======
    pushd ../../../iaito-translations
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    make install -j$NIX_BUILD_CORES PREFIX=$out
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
