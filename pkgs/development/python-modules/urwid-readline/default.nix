{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, urwid
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "urwid-readline";
  version = "0.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rr-";
    repo = "urwid_readline";
    rev = "refs/tags/${version}";
    hash = "sha256-D6NHK6jBSsr0yEAqD4wseaBAn9uSrmx5TpnWMK5BM3k=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    urwid
  ];

  pythonImportsCheck = [ "urwid_readline" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A textbox edit widget for urwid that supports readline shortcuts";
    homepage = "https://github.com/rr-/urwid_readline";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
