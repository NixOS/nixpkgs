{ lib
, buildPythonPackage
, isPy3k
, fetchFromGitHub
, attrs
, click
, colorama
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "shamir-mnemonic";
  version = "0.2.2";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "trezor";
    repo = "python-${pname}";
    rev = "v${version}";
    hash = "sha256-b9tBXN9dBdAeGg3xf5ZBdd6kPpFzseJl6wRTTfNZEwo=";
  };

  propagatedBuildInputs = [
    attrs
    click
    colorama
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "shamir_mnemonic" ];

  meta = with lib; {
    description = "Reference implementation of SLIP-0039";
    homepage = "https://github.com/trezor/python-shamir-mnemonic";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
  };
}
