{
  lib,
  asn1crypto,
  buildPythonPackage,
  fetchFromCodeberg,
  hatchling,
  pytest-mock,
  pytestCheckHook,
  versioningit,
}:

buildPythonPackage rec {
  pname = "scramp";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromCodeberg {
    owner = "tlocke";
    repo = "scramp";
    rev = version;
    hash = "sha256-S46M5nzBg4dhsb0xZVmeKIU5K9z5CtjmL9xa+vJ9fAw=";
  };

  build-system = [
    hatchling
    versioningit
  ];

  dependencies = [ asn1crypto ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  postPatch = ''
    # Upstream uses versioningit to set the version
    sed -i "/versioningit >=/d" pyproject.toml
    sed -i '/^name =.*/a version = "${version}"' pyproject.toml
    sed -i "/dynamic =/d" pyproject.toml
  '';

  pythonImportsCheck = [ "scramp" ];

  disabledTests = [ "test_readme" ];

  meta = {
    description = "Implementation of the SCRAM authentication protocol";
    homepage = "https://github.com/tlocke/scramp";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
