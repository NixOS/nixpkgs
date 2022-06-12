{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "tgcrypto";
  version = "1.2.3";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "pyrogram";
    repo = "tgcrypto";
    rev = "v${version}";
    sha256 = "06g1kv3skq2948h0sjf64s1cr2p1rhxnx5pf9nmvhxkmri1xmfzs";
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
