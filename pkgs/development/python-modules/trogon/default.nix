{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  click,
  textual,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "trogon";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Textualize";
    repo = "trogon";
    rev = "v${version}";
    hash = "sha256-5FMivnQ/+39MmYUmkAZwtH09FpTYDEDtsdmTrUCLHqY=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    click
    textual
  ];

  pythonImportsCheck = [ "trogon" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Easily turn your Click CLI into a powerful terminal application";
    homepage = "https://github.com/Textualize/trogon";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ edmundmiller ];
  };
}
