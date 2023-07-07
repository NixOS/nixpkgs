{ lib
, mkDerivation
, fetchurl
, imagemagick
, pcsclite
, pyotherside
, python3
, qmake
, qtbase
, qtgraphicaleffects
, qtquickcontrols2
, yubikey-manager4
, yubikey-personalization
}:

mkDerivation rec {
  pname = "yubikey-manager-qt";
  version = "1.2.5";

  src = fetchurl {
    url = "https://developers.yubico.com/${pname}/Releases/${pname}-${version}.tar.gz";
    sha256 = "sha256-6bKeR3UX2DhXGcKJ1bxvT1aLTgCfc+aNo6ckE89NV+I=";
  };

  nativeBuildInputs = [
    python3.pkgs.wrapPython
    qmake
    imagemagick
  ];

  postPatch = ''
    substituteInPlace ykman-gui/deployment.pri --replace '/usr/bin' "$out/bin"
  '';

  buildInputs = [
    pyotherside
    python3
    qtbase
    qtgraphicaleffects
    qtquickcontrols2
  ];

  pythonPath = [
    (yubikey-manager4.override { python3Packages = python3.pkgs; })
  ];

  postInstall = ''
    # Desktop files
    install -D -m0644 resources/ykman-gui.desktop "$out/share/applications/ykman-gui.desktop"
    substituteInPlace "$out/share/applications/ykman-gui.desktop" \
      --replace Exec=ykman-gui "Exec=$out/bin/ykman-gui"

    # Icons
    install -Dt $out/share/ykman-gui/icons resources/icons/*.{icns,ico}
    install -D -m0644 resources/icons/ykman.png "$out/share/icons/hicolor/128x128/apps/ykman.png"
    ln -s -- "$out/share/icons/hicolor/128x128/apps/ykman.png" "$out/share/icons/hicolor/128x128/apps/ykman-gui.png"
    for SIZE in 16 24 32 48 64 96; do
      # set modify/create for reproducible builds
      convert -scale ''${SIZE} +set date:create +set date:modify \
        resources/icons/ykman.png ykman.png

      imageFolder="$out/share/icons/hicolor/''${SIZE}x''${SIZE}/apps"
      install -D -m0644 ykman.png "$imageFolder/ykman.png"
      ln -s -- "$imageFolder/ykman.png" "$imageFolder/ykman-gui.png"
    done
    unset SIZE imageFolder
  '';

  qtWrapperArgs = [
    "--prefix" "LD_LIBRARY_PATH" ":" (lib.makeLibraryPath [ pcsclite yubikey-personalization ])
  ];

  preFixup = ''
    buildPythonPath "$pythonPath"
    qtWrapperArgs+=(--prefix PYTHONPATH : "$program_PYTHONPATH")
  '';

  meta = with lib; {
    description = "Cross-platform application for configuring any YubiKey over all USB interfaces";
    homepage = "https://developers.yubico.com/yubikey-manager-qt/";
    license = licenses.bsd2;
    maintainers = [ maintainers.cbley ];
    mainProgram = "ykman-gui";
    platforms = platforms.linux;
  };
}
