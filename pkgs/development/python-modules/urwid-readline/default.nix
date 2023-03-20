{ lib
, buildPythonPackage
, fetchPypi
, urwid
, glibcLocales
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "urwid_readline";
  version = "0.13";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AYAgy8hku17Ye+F9wmsGnq4nVcsp86nFaarDve0e+vQ=";
  };

  propagatedBuildInputs = [
    urwid
  ];

  nativeCheckInputs = [
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
