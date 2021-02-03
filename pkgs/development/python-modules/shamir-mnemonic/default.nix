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
  version = "0.2.0";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "trezor";
    repo = "python-${pname}";
    rev = "v${version}";
    sha256 = "0lkkbl50n8g5z44x7rk1ly6ld0vlassahwagm8b15bvxfi0q9yqb";
  };

  propagatedBuildInputs = [
    attrs
    click
    colorama
  ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "shamir_mnemonic" ];

  meta = with lib; {
    description = "Reference implementation of SLIP-0039";
    homepage = "https://github.com/trezor/python-shamir-mnemonic";
    license = licenses.mit;
    maintainers = with maintainers; [ _1000101 prusnak ];
  };
}
