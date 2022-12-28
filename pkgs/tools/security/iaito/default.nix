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
  version = "5.8.0";

  srcs = [
    (fetchFromGitHub rec {
      owner = "radareorg";
      repo = "iaito";
      rev = version;
      hash = "sha256-LqJu30Bp+JgB+y3MDyPVuFmEoXTpfA7K2pxv1ZCABx0=";
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
  NIX_CFLAGS_COMPILE = [ "-I" "${radare2.src}/shlr/sdb/include/sdb" ];

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
