{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  virtualenv,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "virtualenv-clone";
  version = "0.5.7";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "edwardgeorge";
    repo = "virtualenv-clone";
    rev = version;
    hash = "sha256-qrN74IwLRqiVPxU8gVhdiM34yBmiS/5ot07uroYPDVw=";
  };

  postPatch = ''
    substituteInPlace tests/__init__.py \
      --replace-fail "'virtualenv'" "'${virtualenv}/bin/virtualenv'" \
      --replace-fail "'3.9', '3.10']" "'3.9', '3.10', '3.11', '3.12', '3.13']" # if the Python version used isn't in this list, tests fail

    substituteInPlace tests/test_virtualenv_sys.py \
      --replace-fail "'virtualenv'" "'${virtualenv}/bin/virtualenv'"

    # PermissionError: [Errno 13] Permission denied: '/tmp/test_fixup_pth_file.pth'
    # Unable to reproduce.
    # Theory: this fixed path may collide with itself on darwin if this package is built for multiple python versions simultaneously
    substituteInPlace tests/test_fixup_scripts.py \
      --replace-fail \
        "pth = '/tmp/test_fixup_pth_file.pth'" \
        "pth = '$(mktemp -d)/test_fixup_pth_file.pth'"
  '';

  propagatedBuildInputs = [ virtualenv ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    homepage = "https://github.com/edwardgeorge/virtualenv-clone";
    description = "Script to clone virtualenvs";
    mainProgram = "virtualenv-clone";
    license = licenses.mit;
    maintainers = [ ];
  };
}
