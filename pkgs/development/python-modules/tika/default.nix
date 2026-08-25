{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchPypi,
  pyyaml,
  requests,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "tika";
  version = "3.3.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-RopTAiSRYjUfZc/gVjLThpwDUNcmrvgqdeewT6XKyKs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    beautifulsoup4
    pyyaml
    requests
  ];

  # Requires network
  doCheck = false;

  pythonImportsCheck = [ "tika" ];

  meta = {
    description = "Python binding to the Apache Tika™ REST services";
    homepage = "https://github.com/chrismattmann/tika-python";
    changelog = "https://github.com/chrismattmann/tika-python/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ Flakebi ];
    mainProgram = "tika-python";
  };
})
