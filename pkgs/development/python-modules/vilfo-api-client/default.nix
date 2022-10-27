{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools-scm
, getmac
, requests
, semver
, pytestCheckHook
, responses
}:

buildPythonPackage rec {
  pname = "vilfo-api-client";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "ManneW";
    repo = "vilfo-api-client-python";
    rev = version;
    sha256 = "sha256-j06Bbv0hWSmrlCv8RfgvfGTyOF+vSX+zZnX3AvG5Hys=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "get-mac" "getmac"
  '';

  nativeBuildInputs = [
    setuptools-scm
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  propagatedBuildInputs = [
    getmac
    requests
    semver
  ];

  checkInputs = [
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [ "vilfo" ];

  meta = with lib; {
    description = "Simple wrapper client for the Vilfo router API";
    homepage = "https://github.com/ManneW/vilfo-api-client-python";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
