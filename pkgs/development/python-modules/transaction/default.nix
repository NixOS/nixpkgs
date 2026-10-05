{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  zope-interface,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "transaction";
  version = "5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "transaction";
    tag = version;
    hash = "sha256-db6oEea+sIK9SN7fDP19qYgUgbeH9bv3vuQdssq78vo=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools >= 78.1.1,< 81" "setuptools"
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    zope-interface
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "transaction" ];

  meta = {
    description = "Transaction management";
    homepage = "https://transaction.readthedocs.io/";
    changelog = "https://github.com/zopefoundation/transaction/blob/${version}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
