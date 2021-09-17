{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "tgcrypto";
  version = "1.2.2";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "pyrogram";
    repo = "tgcrypto";
    rev = "v${version}";
    sha256 = "1vyjycjb2n790371kf47qc0mkvd4bxmhh65cfxjsrcjpiri7shjf";
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
