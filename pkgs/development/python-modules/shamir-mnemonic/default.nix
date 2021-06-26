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
  version = "0.2.1";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "trezor";
    repo = "python-${pname}";
    rev = "v${version}";
    sha256 = "1mi1n01yw8yycbiv1l0xnfzlhhq2arappyvyi2jm5yq65jln77kg";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "click>=7,<8" "click"
  '';

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
