{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  anyio,
  hatchling,
  httpx,
}:

buildPythonPackage rec {
  pname = "tika-client";
  version = "0.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "stumpylog";
    repo = "tika-client";
    tag = version;
    hash = "sha256-XYyMp+02lWzE+3Txr+shVGVwalLEJHvoy988tA7SWgY=";
  };

  build-system = [ hatchling ];

  dependencies = [
    anyio
    httpx
  ];

  pythonImportsCheck = [ "tika_client" ];

  # The tests expect the tika-server to run in a docker container
  doChecks = false;

  meta = with lib; {
    description = "Modern Python REST client for Apache Tika server";
    homepage = "https://github.com/stumpylog/tika-client";
    changelog = "https://github.com/stumpylog/tika-client/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ e1mo ];
  };
}
