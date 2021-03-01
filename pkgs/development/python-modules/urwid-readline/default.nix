{ lib
, buildPythonPackage
, fetchPypi
, urwid
, glibcLocales
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "urwid_readline";
  version = "0.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f7384e03017c3fb07bfba0d829d70287793326d9f6dac145dd09e0d693d7bf9c";
  };

  propagatedBuildInputs = [
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
