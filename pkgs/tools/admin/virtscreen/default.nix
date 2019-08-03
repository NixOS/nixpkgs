{ stdenv, fetchFromGitHub, python3Packages, x11vnc, xrandr, libGL }:

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

  propagatedBuildInputs = with python3Packages; [
    netifaces
    pyqt5
    quamash
    x11vnc
    xrandr
  ];

  postPatch = let
    ext = stdenv.hostPlatform.extensions.sharedLibrary; in ''
    substituteInPlace virtscreen/__main__.py \
      --replace "'GL'" "'${libGL}/lib/libGL${ext}'" \
  '';

  meta = with stdenv.lib; {
    description = "Make your iPad/tablet/computer as a secondary monitor on Linux";
    homepage = https://github.com/kbumsik/VirtScreen;
    license = licenses.gpl3;
    maintainers = with maintainers; [ borisbabic ];
  };
}
