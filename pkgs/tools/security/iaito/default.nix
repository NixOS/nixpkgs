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
, nix-update-script
}:

# TODO MacOS support.
# TODO Build and install translations.

stdenv.mkDerivation rec {
  pname = "iaito";
  version = "5.7.2";

  src = fetchFromGitHub {
    owner = "radareorg";
    repo = pname;
    rev = version;
    sha256 = "sha256-5/G5wfdc6aua90XLP3B7Ruy8F3NTXzWfQE6yVDZ0rX8=";
  };

  nativeBuildInputs = [ meson ninja pkg-config python3 qttools wrapQtAppsHook ];

  buildInputs = [ radare2 qtbase ];

  postUnpack = ''
    sourceRoot=$sourceRoot/src
  '';

  # TODO Fix version checking and version information for r2.
  # Version checking always fails due to values being empty strings for some
  # reason. Meanwhile, we can safely assume that radare2's runtime and
  # compile-time implementations are the same and remove this check.
  patches = [ ./remove-broken-version-check.patch ];

  installPhase = ''
    runHook preInstall

    install -m755 -Dt $out/bin iaito
    install -m644 -Dt $out/share/metainfo $src/src/org.radare.iaito.appdata.xml
    install -m644 -Dt $out/share/applications $src/src/org.radare.iaito.desktop
    install -m644 -Dt $out/share/pixmaps $src/src/img/iaito-o.svg

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    attrPath = pname;
  };

  meta = with lib; {
    description = "An official graphical interface of radare2";
    longDescription = ''
      iaito is the official graphical interface of radare2. It's the
      continuation of Cutter for radare2 after the Rizin fork.
    '';
    homepage = "https://radare.org/n/iaito.html";
    changelog = "https://github.com/radareorg/iaito/releases/tag/${src.rev}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ azahi ];
    platforms = platforms.linux;
  };
}
