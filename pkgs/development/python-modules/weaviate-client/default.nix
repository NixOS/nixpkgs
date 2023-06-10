{ lib
, authlib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools-scm
, tqdm
, validators
}:

buildPythonPackage rec {
  pname = "weaviate-client";
  version = "3.19.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZiyypfbazCyc322y33Dpo6ydGLQE0ML/lx2cuF2E6+0=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "validators>=0.18.2,<0.20.0" "validators>=0.18.2" \
      --replace "requests>=2.28.0,<2.29.0" "requests>=2.28.0"
  '';

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    authlib
    tqdm
    validators
  ];

  doCheck = false;

  pythonImportsCheck = [
    "weaviate"
  ];

  meta = with lib; {
    description = "Python native client for easy interaction with a Weaviate instance";
    homepage = "https://github.com/weaviate/weaviate-python-client";
    changelog = "https://github.com/weaviate/weaviate-python-client/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
