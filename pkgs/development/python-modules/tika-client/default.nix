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
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "stumpylog";
    repo = "tika-client";
    tag = version;
    hash = "sha256-ZXtNHjdbAzur6lRZIom+wDMhXgpqQxvHPQMxjXJDwlw=";
  };

  build-system = [ hatchling ];

  dependencies = [
    anyio
    httpx
  ];

  pythonImportsCheck = [ "tika_client" ];

  # The tests expect the tika-server to run in a docker container
  doChecks = false;

  meta = {
    description = "Modern Python REST client for Apache Tika server";
    homepage = "https://github.com/stumpylog/tika-client";
    changelog = "https://github.com/stumpylog/tika-client/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ e1mo ];
  };
}
