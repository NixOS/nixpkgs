{
  lib,
  asn1crypto,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  importlib-metadata,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  versioningit,
}:

buildPythonPackage rec {
  pname = "scramp";
  version = "1.4.5";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tlocke";
    repo = "scramp";
    rev = "refs/tags/${version}";
    hash = "sha256-KpododRJ+CYRGBR7Sr5cVBhJvUwh9YmPERd/DAJqEcY=";
  };

  build-system = [ hatchling ];

  nativeBuildInputs = [ versioningit ];

  dependencies = [ asn1crypto ] ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

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

  meta = with lib; {
    description = "Implementation of the SCRAM authentication protocol";
    homepage = "https://github.com/tlocke/scramp";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
