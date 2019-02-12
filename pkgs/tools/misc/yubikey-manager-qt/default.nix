{ stdenv
, fetchurl
, makeWrapper
, pcsclite
, pyotherside
, pythonPackages
, python3
, qmake
, qt5
, yubikey-manager
, yubikey-personalization
}:

with stdenv;

let
  qmlPath = qmlLib: "${qmlLib}/${qt5.qtbase.qtQmlPrefix}";

  qml2ImportPath = lib.concatMapStringsSep ":" qmlPath [
    qt5.qtbase.bin qt5.qtdeclarative.bin pyotherside qt5.qtquickcontrols qt5.qtquickcontrols2.bin qt5.qtgraphicaleffects
  ];

in stdenv.mkDerivation rec {
  pname = "yubikey-manager-qt";
  version = "1.1.0";

  src = fetchurl {
    url = "https://developers.yubico.com/yubikey-manager-qt/Releases/${pname}-${version}.tar.gz";
    sha256 = "8049a233a8cca07543d745a9f619c0fc3afb324f5d0030b93f037b34ac1c5e66";
  };

  nativeBuildInputs = [ makeWrapper python3.pkgs.wrapPython qmake ];

  sourceRoot = ".";

  postPatch = ''
    substituteInPlace ykman-gui/deployment.pri --replace '/usr/bin' "$out/bin"
  '';

  buildInputs = [ pythonPackages.python qt5.qtbase qt5.qtgraphicaleffects qt5.qtquickcontrols qt5.qtquickcontrols2 pyotherside ];

  enableParallelBuilding = true;

  pythonPath = [ yubikey-manager ];

  # Need LD_PRELOAD for libykpers as the Nix cpython disables ctypes.cdll.LoadLibrary
  # support that the yubicommon library uses to load libykpers
  postInstall = ''
    buildPythonPath "$pythonPath"

    wrapProgram $out/bin/ykman-gui \
      --prefix PYTHONPATH : "$program_PYTHONPATH" \
      --prefix LD_PRELOAD : "${yubikey-personalization}/lib/libykpers-1.so" \
      --prefix LD_LIBRARY_PATH : "${stdenv.lib.getLib pcsclite}/lib:${yubikey-personalization}/lib" \
      --set QML2_IMPORT_PATH "${qml2ImportPath}" \
      --set QT_QPA_PLATFORM_PLUGIN_PATH ${qt5.qtbase.bin}/lib/qt-*/plugins/platforms \
      --prefix QT_PLUGIN_PATH : "${qt5.qtsvg.bin}/${qt5.qtbase.qtPluginPrefix}"

      mkdir -p $out/share/applications
      cp resources/ykman-gui.desktop $out/share/applications/ykman-gui.desktop
      mkdir -p $out/share/ykman-gui/icons
      cp resources/icons/*.{icns,ico,png,xpm} $out/share/ykman-gui/icons
      substituteInPlace $out/share/applications/ykman-gui.desktop \
        --replace 'Exec=ykman-gui' "Exec=$out/bin/ykman-gui" \
  '';

  meta = with stdenv.lib; {
    inherit version;
    description = "Cross-platform application for configuring any YubiKey over all USB interfaces.";
    homepage = https://developers.yubico.com/yubikey-manager-qt/;
    license = licenses.bsd2;
    maintainers = [ maintainers.cbley ];
    platforms = platforms.linux;
  };
}
