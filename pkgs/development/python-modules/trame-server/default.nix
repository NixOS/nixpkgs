{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
  wslink,
  more-itertools,
}:

buildPythonPackage (finalAttrs: {
  name = "trame-server";
  version = "3.10.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Kitware";
    repo = "trame-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M3UQYJlo539y3M0LyxkHeQJgpVt+AkSXyjpVpukdV8w=";
  };

  pyproject = true;
  build-system = [
    setuptools
  ];
  propagatedBuildInputs = [
    wslink
    more-itertools
  ];

  pythonImportsCheck = [
    "trame_server.utils"
    "trame_server.client"
    "trame_server.controller"
    "trame_server.core"
    "trame_server.http"
    "trame_server.protocol"
    "trame_server.state"
    "trame_server.ui"
  ];

  meta = {
    description = "Internal server side implementation of trame";
    homepage = "https://github.com/kitware/trame-server";
    maintainers = with lib.maintainers; [ BrockoliniMorgan ];
    license = lib.licenses.asl20;
  };
})
