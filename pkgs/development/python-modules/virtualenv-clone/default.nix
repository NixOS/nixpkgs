{ lib
, buildPythonPackage
, fetchFromGitHub
, virtualenv
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "virtualenv-clone";
  version = "0.5.7";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "edwardgeorge";
    repo = pname;
    rev = version;
    sha256 = "sha256-qrN74IwLRqiVPxU8gVhdiM34yBmiS/5ot07uroYPDVw=";
  };

  postPatch = ''
    substituteInPlace tests/__init__.py \
      --replace "'virtualenv'" "'${virtualenv}/bin/virtualenv'"

    substituteInPlace tests/test_virtualenv_sys.py \
      --replace "'virtualenv'" "'${virtualenv}/bin/virtualenv'"
  '';

  propagatedBuildInputs = [
    virtualenv
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/edwardgeorge/virtualenv-clone";
    description = "Script to clone virtualenvs";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
