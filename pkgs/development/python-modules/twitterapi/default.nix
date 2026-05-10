{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  requests-oauthlib,
}:

buildPythonPackage rec {
  pname = "twitterapi";
  version = "2.8.2";
  format = "setuptools";

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

  meta = {
    description = "Python wrapper for Twitter's REST and Streaming APIs";
    homepage = "https://github.com/geduldig/TwitterAPI";
    changelog = "https://github.com/geduldig/TwitterAPI/blob/v${version}/CHANGE.log";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
