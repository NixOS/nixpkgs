{ lib
, buildPythonPackage
, fetchFromGitHub
, virtualenv
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "virtualenv-clone";
  version = "0.5.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "edwardgeorge";
    repo = pname;
    rev = version;
    sha256 = "0xb20fhl99dw5vnyb43sjpj9628nbdnwp5g7m8f2id7w8kpwzvfw";
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

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/edwardgeorge/virtualenv-clone";
    description = "Script to clone virtualenvs";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
