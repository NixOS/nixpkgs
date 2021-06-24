{ python3Packages
, fetchFromGitHub
, wrapQtAppsHook
, lib
}:

python3Packages.buildPythonApplication rec {
  pname = "opensnitch-ui";
  version = "1.3.6";

  src = fetchFromGitHub {
    owner = "evilsocket";
    repo = "opensnitch";
    rev = "v${version}";
    sha256 = "sha256-Cgo+bVQQeUZuYYhA1WSqlLyQQGAeXbbNno9LS7oNvhI=";
  };

  nativeBuildInputs = [ wrapQtAppsHook ];

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
