{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
  x11vnc,
  xrandr,
  libGL,
  qt5,
}:

python3Packages.buildPythonApplication rec {
  pname = "virtscreen";
  version = "0.3.1";

  disabled = python3Packages.pythonOlder "3.6";

  # No tests
  doCheck = false;

  src = fetchFromGitHub {
    owner = "kbumsik";
    repo = pname;
    rev = version;
    sha256 = "005qach6phz8w17k8kqmyd647c6jkfybczybxq0yxi5ik0s91a08";
  };

  nativeBuildInputs = [ qt5.wrapQtAppsHook ];

  propagatedBuildInputs = with python3Packages; [
    netifaces
    pyqt5
    quamash
    x11vnc
    xrandr
  ];

  dontWrapQtApps = true;

  makeWrapperArgs = [
    "\${qtWrapperArgs[@]}"
    # import Qt.labs.platform failed without this
    "--prefix QML2_IMPORT_PATH : ${qt5.qtquickcontrols2.bin}/${qt5.qtbase.qtQmlPrefix}"
  ];

  postPatch = ''
    substituteInPlace virtscreen/__main__.py \
      --replace "'GL'" "'${libGL}/lib/libGL${stdenv.hostPlatform.extensions.sharedLibrary}'" \
  '';

  meta = with lib; {
    description = "Make your iPad/tablet/computer as a secondary monitor on Linux";
    homepage = "https://github.com/kbumsik/VirtScreen";
    license = licenses.gpl3;
    maintainers = with maintainers; [ borisbabic ];
  };
}
