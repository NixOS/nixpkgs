{ stdenv
, fetchurl
, wrapQtAppsHook
, pcsclite
, pyotherside
, pythonPackages
, python3
, qmake
, qtbase
, qtgraphicaleffects
, qtquickcontrols
, qtquickcontrols2
, qtdeclarative
, qtsvg
, yubikey-manager
, yubikey-personalization
}:

let inherit (stdenv) lib; in

stdenv.mkDerivation rec {
  pname = "yubikey-manager-qt";
  version = "1.1.4";

  src = fetchurl {
    url = "https://developers.yubico.com/${pname}/Releases/${pname}-${version}.tar.gz";
    sha256 = "0rbr72741q7fqkr9qmvgj2mi6192ayz7bl935q2bsnqils4wsa3f";
  };

  nativeBuildInputs = [ wrapQtAppsHook python3.pkgs.wrapPython qmake ];

  postPatch = ''
    substituteInPlace ykman-gui/deployment.pri --replace '/usr/bin' "$out/bin"
  '';

  buildInputs = [ pythonPackages.python qtbase qtgraphicaleffects qtquickcontrols qtquickcontrols2 pyotherside ];

  enableParallelBuilding = true;

  pythonPath = [ yubikey-manager ];

  dontWrapQtApps = true;
  postInstall = ''
    buildPythonPath "$pythonPath"

    wrapQtApp $out/bin/ykman-gui \
      --prefix LD_LIBRARY_PATH : "${stdenv.lib.getLib pcsclite}/lib:${yubikey-personalization}/lib" \
      --prefix PYTHONPATH : "$program_PYTHONPATH"

    mkdir -p $out/share/applications
    cp resources/ykman-gui.desktop $out/share/applications/ykman-gui.desktop
    mkdir -p $out/share/ykman-gui/icons
    cp resources/icons/*.{icns,ico,png,xpm} $out/share/ykman-gui/icons
    substituteInPlace $out/share/applications/ykman-gui.desktop \
      --replace 'Exec=ykman-gui' "Exec=$out/bin/ykman-gui" \
  '';

  meta = with lib; {
    inherit version;
    description = "Cross-platform application for configuring any YubiKey over all USB interfaces.";
    homepage = https://developers.yubico.com/yubikey-manager-qt/;
    license = licenses.bsd2;
    maintainers = [ maintainers.cbley ];
    platforms = platforms.linux;
  };
}
