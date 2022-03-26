{ python3Packages
, fetchFromGitHub
, wrapQtAppsHook
, lib
}:

python3Packages.buildPythonApplication rec {
  pname = "opensnitch-ui";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "evilsocket";
    repo = "opensnitch";
    rev = "v${version}";
    sha256 = "sha256-vtD82v0VlaJtCICXduD3IxJ0xjlBuzGKLWLoCiwPX2I=";
  };

  nativeBuildInputs = [
    python3Packages.pyqt5
    wrapQtAppsHook
  ];

  propagatedBuildInputs = with python3Packages; [
    grpcio-tools
    pyqt5
    unidecode
    unicode-slugify
    pyinotify
    notify2
    pyasn
  ];

  preBuild = ''
    make -C ../proto ../ui/opensnitch/ui_pb2.py
    pyrcc5 -o opensnitch/resources_rc.py opensnitch/res/resources.qrc
  '';

  preConfigure = ''
    cd ui
  '';

  preCheck = ''
    export PYTHONPATH=opensnitch:$PYTHONPATH
  '';

  postInstall = ''
    mv $out/lib/python3.9/site-packages/usr/* $out/
  '';

  dontWrapQtApps = true;
  makeWrapperArgs = [ "\${qtWrapperArgs[@]}" ];

  # All tests are sandbox-incompatible and disabled for now
  doCheck = false;

  meta = with lib; {
    description = "An application firewall";
    homepage = "https://github.com/evilsocket/opensnitch/wiki";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.raboof ];
    platforms = platforms.linux;
  };
}
