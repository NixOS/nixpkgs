{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pypng
, pyzbar
}:

buildPythonPackage rec {
  pname = "segno";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "heuer";
    repo = "segno";
    rev = version;
    hash = "sha256-+OEXG5OvrZ5Ft7IO/7zodf+SgiRF+frwjltrBENNnHo=";
  };

  nativeCheckInputs = [
    pytestCheckHook
    pypng
    pyzbar
  ];

  pythonImportsCheck = [ "segno" ];

  meta = with lib; {
    description = "QR Code and Micro QR Code encoder";
    homepage = "https://github.com/heuer/segno/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ phaer ];
  };
}
