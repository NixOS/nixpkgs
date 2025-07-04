{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  lxml,
  poetry-core,
  pythonOlder,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "xpath-expressions";
  version = "1.1.0";
  format = "pyproject";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "orf";
    repo = "xpath-expressions";
    rev = "v${version}";
    hash = "sha256-UAzDXrz1Tr9/OOjKAg/5Std9Qlrnizei8/3XL3hMSFA=";
  };

  patches = [
    # https://github.com/orf/xpath-expressions/pull/4
    (fetchpatch {
      name = "replace-poetry-with-poetry-core.patch";
      url = "https://github.com/orf/xpath-expressions/commit/3c5900fd6b2d08dd9468707f35ab42072cf75bd3.patch";
      hash = "sha256-IeV6ncJyt/w2s5TPpbM5a3pljNT6Bp5PIiqgTg2iTRA=";
    })
  ];

  nativeBuildInputs = [ poetry-core ];

  nativeCheckInputs = [
    lxml
    pytestCheckHook
  ];

  pythonImportsCheck = [ "xpath" ];

  meta = with lib; {
    description = "Python module to handle XPath expressions";
    homepage = "https://github.com/orf/xpath-expressions";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
