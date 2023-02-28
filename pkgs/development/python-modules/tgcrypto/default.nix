{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "tgcrypto";
  version = "1.2.5";

  disabled = pythonOlder "3.6";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pyrogram";
    repo = "tgcrypto";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-u+mXzkmM79NBi4oHnb32RbN9WPnba/cm1q2Ko0uNEZg=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "tgcrypto" ];

  meta = with lib; {
    description = "Fast and Portable Telegram Crypto Library for Python";
    homepage = "https://github.com/pyrogram/tgcrypto";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
