{
  lib,
  buildPythonApplication,
  fetchPypi,
  pythonOlder,
  pythonRelaxDepsHook,

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
    pythonRelaxDepsHook
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

  meta = with lib; {
    description = "Automatically test services/checker using the enochecker API";
    mainProgram = "enochecker_test";
    homepage = "https://github.com/enowars/enochecker_test";
    changelog = "https://github.com/enowars/enochecker_test/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fwc ];
  };
}
