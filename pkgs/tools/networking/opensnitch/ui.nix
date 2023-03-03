{ python3Packages
, fetchFromGitHub
, wrapQtAppsHook
, lib
}:

python3Packages.buildPythonApplication rec {
  pname = "opensnitch-ui";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "evilsocket";
    repo = "opensnitch";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-MF7K3WasG1xLdw1kWz6xVYrdfuZW5GUq6dlS0pPOkHI=";
  };

  postPatch = ''
    substituteInPlace ui/opensnitch/utils.py \
      --replace /usr/lib/python3/dist-packages/data ${python3Packages.pyasn}/${python3Packages.python.sitePackages}/pyasn/data
  '';

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
    # sourced from ui/Makefile
    pyrcc5 -o opensnitch/resources_rc.py opensnitch/res/resources.qrc
    sed -i 's/^import ui_pb2/from . import ui_pb2/' opensnitch/ui_pb2*
  '';

  preConfigure = ''
    cd ui
  '';

  preCheck = ''
    export PYTHONPATH=opensnitch:$PYTHONPATH
  '';

  postInstall = ''
    mv $out/${python3Packages.python.sitePackages}/usr/* $out/
  '';

  dontWrapQtApps = true;
  makeWrapperArgs = [ "\${qtWrapperArgs[@]}" ];

  # All tests are sandbox-incompatible and disabled for now
  doCheck = false;

  meta = with lib; {
    description = "An application firewall";
    homepage = "https://github.com/evilsocket/opensnitch/wiki";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ onny ];
    platforms = platforms.linux;
  };
}
