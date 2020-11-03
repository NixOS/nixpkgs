{ lib
, buildPythonPackage
, fetchPypi
, urwid
, glibcLocales
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "urwid_readline";
  version = "0.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "24e376d4b75940d19e8bc81c264be5d383f8d4da560f68f648dd16c85f6afdb5";
  };

  requiredPythonModules = [
    urwid
  ];

  checkInputs = [
    glibcLocales
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A textbox edit widget for urwid that supports readline shortcuts";
    homepage = "https://github.com/rr-/urwid_readline";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
