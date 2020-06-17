{ lib, fetchPypi, buildPythonPackage, pytest }:

buildPythonPackage rec {
  pname = "wcwidth";
  version = "0.1.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ee73862862a156bf77ff92b09034fc4825dd3af9cf81bc5b360668d425f3c5f1";
  };

  checkInputs = [ pytest ];

  # To prevent infinite recursion with pytest
  doCheck = false;

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Measures number of Terminal column cells of wide-character codes";
    longDescription = ''
      This API is mainly for Terminal Emulator implementors -- any Python
      program that attempts to determine the printable width of a string on
      a Terminal. It is implemented in python (no C library calls) and has
      no 3rd-party dependencies.
    '';
    homepage = "https://github.com/jquast/wcwidth";
    license = licenses.mit;
  };
}
