{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchurl,
  hatchling,
  pyyaml,
  more-itertools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "tap.py";
  version = "3.2.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  # fetchPypi doesn't work, cf. https://github.com/NixOS/nixpkgs/issues/369009
  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/37/d0/28b0c6c7fe464f70664f123e9f64f36acaf92767af98c1a82df6e2b49f41/tap_py-3.2.1.tar.gz";
    hash = "sha256-0DyeavClb62ZTxxp8UBB5naBHXPu7vIL9Ad8Q9Yh1gg=";
  };

  build-system = [
    hatchling
  ];

  optional-dependencies = {
    yaml = [
      pyyaml
      more-itertools
    ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "tap" ];

  meta = with lib; {
    description = "Set of tools for working with the Test Anything Protocol (TAP) in Python";
    homepage = "https://github.com/python-tap/tappy";
    changelog = "https://tappy.readthedocs.io/en/latest/releases.html";
    mainProgram = "tappy";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sfrijters ];
  };
}
