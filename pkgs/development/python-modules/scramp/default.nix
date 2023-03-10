{ lib
, asn1crypto
, buildPythonPackage
, fetchFromGitHub
, importlib-metadata
, pytest-mock
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "scramp";
  version = "1.4.4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tlocke";
    repo = "scramp";
    rev = version;
    hash = "sha256-WOyv1fLSXG7p+WKs2QSwlsh8FSK/lxp6I1hPY0VIkKo=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    asn1crypto
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  postPatch = ''
    # Upstream uses versioningit to set the version
    sed -i '/^name =.*/a version = "${version}"' pyproject.toml
    sed -i "/dynamic =/d" pyproject.toml
  '';

  pythonImportsCheck = [
    "scramp"
  ];

  disabledTests = [
    "test_readme"
  ];

  meta = with lib; {
    description = "Implementation of the SCRAM authentication protocol";
    homepage = "https://github.com/tlocke/scramp";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
