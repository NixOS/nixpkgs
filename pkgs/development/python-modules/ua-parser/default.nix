{ lib
, buildPythonPackage
, fetchFromGitHub
, pyyaml
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "ua-parser";
  version = "0.16.1";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ua-parser";
    repo = "uap-python";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-vyzeRi/wYEyezSU+EigJATgrNvABGCWVWlSFhKGipLE=";
  };

  patches = [
    ./dont-fetch-submodule.patch
  ];

  nativeBuildInputs = [
    pyyaml
  ];

  checkInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    # import from $out
    rm ua_parser/__init__.py
  '';

  pythonImportsCheck = [ "ua_parser" ];

  meta = with lib; {
    description = "A python implementation of the UA Parser";
    homepage = "https://github.com/ua-parser/uap-python";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dotlambda ];
  };
}
