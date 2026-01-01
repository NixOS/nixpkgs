{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  urwid,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "urwid-readline";
  version = "0.15.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rr-";
    repo = "urwid_readline";
    tag = version;
    hash = "sha256-HiMMLzVE/Qw/PR7LXACyfzblxrGYrbMoi3/e/QzqF34=";
  };

  build-system = [ setuptools ];

  dependencies = [ urwid ];

  pythonImportsCheck = [ "urwid_readline" ];

  nativeCheckInputs = [ pytestCheckHook ];

<<<<<<< HEAD
  meta = {
    description = "Textbox edit widget for urwid that supports readline shortcuts";
    homepage = "https://github.com/rr-/urwid_readline";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
=======
  meta = with lib; {
    description = "Textbox edit widget for urwid that supports readline shortcuts";
    homepage = "https://github.com/rr-/urwid_readline";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
