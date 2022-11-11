{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "tgcrypto";
  version = "1.2.4";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "pyrogram";
    repo = "tgcrypto";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-hifRWVEvNZVFyIJPwYY+CDR04F1I9GyAi3dt2kx+81c=";
  };

  checkInputs = [
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
