{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytz,
  requests,
  paho-mqtt,
}:

buildPythonPackage rec {
  pname = "yoto-api";
  version = "2.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cdnninja";
    repo = "yoto_api";
    tag = "v${version}";
    hash = "sha256-bRJjDgmMLJcmWyyxTg0BLjBukGi8JX9WWz9IoUl9Fcw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pytz
    requests
    paho-mqtt
  ];

  # All tests require access to and authentication with the Yoto API (api.yotoplay.com).
  doCheck = false;

  pythonImportsCheck = [ "yoto_api" ];

  meta = {
    changelog = "https://github.com/cdnninja/yoto_api/releases/tag/${src.tag}";
    homepage = "https://github.com/cdnninja/yoto_api";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ seberm ];
    license = lib.licenses.mit;
    description = "Python package that makes it a bit easier to work with the yoto play API";
  };
}
