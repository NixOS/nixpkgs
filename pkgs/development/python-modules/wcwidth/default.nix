{ lib, fetchPypi, buildPythonPackage, pytestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "wcwidth";
  version = "0.2.12";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8BwQTv31eXG8t1bwVN1Y3exSBN0V+jHWUD6leUfZfAI=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # To prevent infinite recursion with pytest
  doCheck = false;

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
