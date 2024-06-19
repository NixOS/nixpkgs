{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  hatchling,
  httpx,
}:
buildPythonPackage rec {
  pname = "tika-client";
  version = "0.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "stumpylog";
    repo = "tika-client";
    rev = "refs/tags/${version}";
    hash = "sha256-fFibRF3SoDOje6M9YmZI0dwYVn/cvgXqmClvqvNy5f8=";
  };

  propagatedBuildInputs = [
    hatchling
    httpx
  ];
  pythonImportsCheck = [ "tika_client" ];
  # Almost all of the tests (all except one in 0.1.0) fail since there
  # is no tika http API endpoint reachable. Since tika is not yet
  # packaged for nixpkgs, it seems like an unreasonable amount of effort
  # fixing these tests.
  doChecks = false;

  meta = with lib; {
    description = "A modern Python REST client for Apache Tika server";
    homepage = "https://github.com/stumpylog/tika-client";
    changelog = "https://github.com/stumpylog/tika-client/blob/${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ e1mo ];
  };
}
