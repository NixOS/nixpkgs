{ lib
, buildPythonApplication
, fetchPypi
, stdenv
, click
, coloredlogs
, psutil
, pycyphal
, pyserial
, ruamel-yaml
, requests
, scipy
, simplejson
}:

buildPythonApplication rec {
  pname = "yakut";
  version = "0.13.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MBVSt01D36rBPW2bopujyu8Opwwavmm7S3tdaWp5ACw=";
  };

  buildInputs = [
    stdenv.cc.cc.lib
    click
    coloredlogs
    psutil
    pycyphal
    pyserial
    ruamel-yaml
    requests
    scipy
    simplejson
  ];

  # Can't seem to run the tests on nix
  doCheck = false;

  meta = with lib; {
    description = "Simple CLI tool for diagnostics and debugging of Cyphal networks";
    longDescription = ''
      Yakút is a simple cross-platform command-line interface (CLI) tool for diagnostics and debugging of Cyphal networks. By virtue of being based on PyCyphal, Yakut supports all Cyphal transports (UDP, serial, CAN, ...) and is compatible with all major features of the protocol. It is designed to be usable with GNU/Linux, Windows, and macOS.
    '';
    homepage = "https://github.com/OpenCyphal/yakut/";
    license = licenses.mit;
    maintainers = teams.ororatech.members;
  };
}
