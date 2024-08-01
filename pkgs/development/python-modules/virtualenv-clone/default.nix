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
    repo = pname;
    rev = version;
    hash = "sha256-qrN74IwLRqiVPxU8gVhdiM34yBmiS/5ot07uroYPDVw=";
  };

  postPatch = ''
    substituteInPlace tests/__init__.py \
      --replace "'virtualenv'" "'${virtualenv}/bin/virtualenv'" \
      --replace "'3.9', '3.10']" "'3.9', '3.10', '3.11', '3.12']" # if the Python version used isn't in this list, tests fail

    substituteInPlace tests/test_virtualenv_sys.py \
      --replace "'virtualenv'" "'${virtualenv}/bin/virtualenv'"
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
