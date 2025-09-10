{
  lib,
  buildPythonApplication,
  fetchPypi,
  stdenv,
  click,
  coloredlogs,
  mido,
  psutil,
  pycyphal,
  pysdl2,
  python-rtmidi,
  ruamel-yaml,
  requests,
  scipy,
  simplejson,
}:

buildPythonApplication rec {
  pname = "yakut";
  version = "0.14.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wCchb0bSnwlEwgb/Oe0gHnkEU3F+cotlvv/WXAr72i8=";
  };

  buildInputs = [
    (lib.getLib stdenv.cc.cc)
  ];
  dependencies = [
    click
    coloredlogs
    psutil
    pycyphal
    ruamel-yaml
    requests
    scipy
    simplejson
  ];
  optional-dependencies.joystick = [
    pysdl2
    mido
    python-rtmidi
  ];

  # All these require extra permissions and/or actual hardware connected
  doCheck = false;

  meta = with lib; {
    description = "Simple CLI tool for diagnostics and debugging of Cyphal networks";
    longDescription = ''
      Yakút is a simple cross-platform command-line interface (CLI) tool for diagnostics and debugging of Cyphal networks. By virtue of being based on PyCyphal, Yakut supports all Cyphal transports (UDP, serial, CAN, ...) and is compatible with all major features of the protocol. It is designed to be usable with GNU/Linux, Windows, and macOS.
    '';
    homepage = "https://github.com/OpenCyphal/yakut/";
    license = licenses.mit;
    teams = [ teams.ororatech ];
  };
}
