{ python3Packages
, fetchFromGitHub
, wrapQtAppsHook
, lib
}:

python3Packages.buildPythonApplication rec {
  pname = "opensnitch-ui";
  version = "1.4.0-rc.1";

  src = fetchFromGitHub {
    owner = "evilsocket";
    repo = "opensnitch";
    rev = "v${version}";
    sha256 = "sha256-UJ46sGdL+YAeb3U9C07tzMpy6FOkLNRq2Z0koF1AL80=";
  };

  nativeBuildInputs = [ python3Packages.pyqt5 wrapQtAppsHook ];

  propagatedBuildInputs = with python3Packages; [
    grpcio-tools
    pyqt5
    unidecode
    unicode-slugify
    pyinotify
  ];

  preConfigure = ''
    cd ui
  '';

  preBuild = ''
    make -C ../proto ../ui/opensnitch/ui_pb2.py
    pyrcc5 -o opensnitch/resources_rc.py opensnitch/res/resources.qrc
  '';

  preCheck = ''
    export PYTHONPATH=opensnitch:$PYTHONPATH
  '';

  dontWrapQtApps = true;
  makeWrapperArgs = [ "\${qtWrapperArgs[@]}" ];

  meta = with lib; {
    description = "An application firewall";
    homepage = "https://github.com/evilsocket/opensnitch/wiki";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.raboof ];
    platforms = platforms.linux;
  };
}
