{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  requests-oauthlib,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "twitterapi";
  version = "2.8.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "geduldig";
    repo = "TwitterAPI";
    tag = "v${version}";
    hash = "sha256-4Z8XfgRhQXawCvaXM+kyMO3fejvXIF2LgVdmfXDDqIA=";
  };

  propagatedBuildInputs = [
    requests
    requests-oauthlib
  ];

  # Tests are interacting with the Twitter API
  doCheck = false;

  pythonImportsCheck = [ "TwitterAPI" ];

  meta = with lib; {
    description = "Python wrapper for Twitter's REST and Streaming APIs";
    homepage = "https://github.com/geduldig/TwitterAPI";
    changelog = "https://github.com/geduldig/TwitterAPI/blob/v${version}/CHANGE.log";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
