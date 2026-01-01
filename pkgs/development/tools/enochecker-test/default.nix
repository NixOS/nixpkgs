{
  lib,
  buildPythonApplication,
  fetchPypi,
  pythonOlder,

  certifi,
  charset-normalizer,
  enochecker-core,
  exceptiongroup,
  idna,
  iniconfig,
  jsons,
  packaging,
  pluggy,
  pytest,
  requests,
  tomli,
  typish,
  urllib3,
}:

buildPythonApplication rec {
  pname = "enochecker-test";
  version = "0.9.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit version;
    pname = "enochecker_test";
    hash = "sha256-M0RTstFePU7O51YVEncVDuuR6F7R8mfdKbO0j7k/o8Q=";
  };

  nativeBuildInputs = [
  ];

  pythonRelaxDeps = true;

  propagatedBuildInputs = [
    certifi
    charset-normalizer
    enochecker-core
    exceptiongroup
    idna
    iniconfig
    jsons
    packaging
    pluggy
    pytest
    requests
    tomli
    typish
    urllib3
  ];

  # tests require network access
  doCheck = false;

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Automatically test services/checker using the enochecker API";
    mainProgram = "enochecker_test";
    homepage = "https://github.com/enowars/enochecker_test";
    changelog = "https://github.com/enowars/enochecker_test/releases/tag/v${version}";
<<<<<<< HEAD
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fwc ];
=======
    license = licenses.mit;
    maintainers = with maintainers; [ fwc ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
