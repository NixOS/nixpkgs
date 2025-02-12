{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  click,
  colorama,
}:

buildPythonPackage rec {
  pname = "shamir-mnemonic";
  version = "0.3.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "trezor";
    repo = "python-${pname}";
    tag = "v${version}";
    hash = "sha256-KjZbxA92h25ghbItdmPvkSPvDZUSRWkl4vnJDBMN71s=";
  };

  build-system = [ poetry-core ];

  propagatedBuildInputs = [
    click
    colorama
  ];

  pythonImportsCheck = [ "shamir_mnemonic" ];

  meta = with lib; {
    description = "Reference implementation of SLIP-0039";
    mainProgram = "shamir";
    homepage = "https://github.com/trezor/python-shamir-mnemonic";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
  };
}
