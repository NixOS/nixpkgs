{ lib
, mkDerivation
, fetchurl
, pcsclite
, pyotherside
, python3
, qmake
, qtbase
, qtgraphicaleffects
, qtquickcontrols2
, yubikey-manager
, yubikey-personalization
}:

mkDerivation rec {
  pname = "yubikey-manager-qt";
  version = "1.2.4";

  src = fetchurl {
    url = "https://developers.yubico.com/${pname}/Releases/${pname}-${version}.tar.gz";
    sha256 = "sha256-PxHc7IeRsO+CPrNTofGypLLW8fSHDkcBqr75NwdlUyc=";
  };

  nativeBuildInputs = [
    python3.pkgs.wrapPython
    qmake
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
    (yubikey-manager.override { python3Packages = python3.pkgs; })
  ];

  postInstall = ''
    install -Dt $out/share/applications resources/ykman-gui.desktop
    install -Dt $out/share/ykman-gui/icons resources/icons/*.{icns,ico,png,xpm}
    substituteInPlace $out/share/applications/ykman-gui.desktop \
      --replace 'Exec=ykman-gui' "Exec=$out/bin/ykman-gui"
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
    platforms = platforms.linux;
  };
}
