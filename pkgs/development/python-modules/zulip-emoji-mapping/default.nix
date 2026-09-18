{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "zulip-emoji-mapping";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "GearKite";
    repo = "zulip-emoji-mapping";
    rev = "v${version}";
    hash = "sha256-logm5uAnLAcFqI7mUxKEO9ZmHqRkd6CFiCW4B5tqZzg=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [
    "zulip_emoji_mapping"
  ];

  meta = {
    description = "Get emojis by Zulip names";
    homepage = "https://github.com/GearKite/zulip-emoji-mapping";
    changelog = "https://github.com/GearKite/zulip-emoji-mapping/releases";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ robertrichter ];
  };
}
