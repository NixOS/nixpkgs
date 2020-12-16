{ fetchurl
, lib
, mkDerivation
, pcsclite
, pyotherside
, python3Packages
, qmake
, qtbase
, qtdeclarative
, qtgraphicaleffects
, qtquickcontrols
, qtquickcontrols2
, qtsvg
, yubikey-manager
, yubikey-personalization
}:

mkDerivation rec {
  pname = "yubikey-manager-qt";
  version = "1.1.5";

  src = fetchurl {
    url = "https://developers.yubico.com/${pname}/Releases/${pname}-${version}.tar.gz";
    sha256 = "1yimlaqvhq34gw6wkqgil0qq8x9zbfzh4psqihjr2d9jaa2wygwy";
  };

  postPatch = ''
    substituteInPlace ykman-gui/deployment.pri \
      --replace /usr/bin $out/bin
  '';

  buildInputs = [ python3Packages.python qtbase qtgraphicaleffects qtquickcontrols qtquickcontrols2 pyotherside ];

  nativeBuildInputs = [ python3Packages.wrapPython qmake ];

  enableParallelBuilding = true;

  pythonPath = [ yubikey-manager ];

  postInstall = ''
    buildPythonPath "$pythonPath"

    qtWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ pcsclite yubikey-personalization]}"
      --prefix PYTHONPATH : "$program_PYTHONPATH"
    )

    install -Dm444 -t $out/share/applications    resources/ykman-gui.desktop
    install -Dm444 -t $out/share/ykman-gui/icons resources/icons/*.{icns,ico,png,xpm}
    substituteInPlace $out/share/applications/ykman-gui.desktop \
      --replace 'Exec=ykman-gui' "Exec=$out/bin/ykman-gui" \
  '';

  meta = with lib; {
    inherit version;
    description = "Cross-platform application for configuring any YubiKey over all USB interfaces";
    homepage = "https://developers.yubico.com/yubikey-manager-qt/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ cbley ];
    platforms = platforms.linux;
  };
}
