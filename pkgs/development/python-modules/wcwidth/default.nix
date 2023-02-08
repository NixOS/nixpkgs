{ lib, fetchPypi, buildPythonPackage, pytestCheckHook
, isPy3k
, backports_functools_lru_cache
, setuptools
}:

buildPythonPackage rec {
  pname = "wcwidth";
  version = "0.2.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  propagatedBuildInputs = [ setuptools ] ++ lib.optionals (!isPy3k) [
    backports_functools_lru_cache
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
