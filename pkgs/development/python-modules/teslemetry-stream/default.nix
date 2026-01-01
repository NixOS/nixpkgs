{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
}:

buildPythonPackage rec {
  pname = "teslemetry-stream";
<<<<<<< HEAD
  version = "0.9.0";
=======
  version = "0.7.10";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Teslemetry";
    repo = "python-teslemetry-stream";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-snJrjHqniI9QKkjV5MuqXM3KZVwe8s8jeFbCcC/QEe8=";
=======
    hash = "sha256-2ZKoDb5ZKo27qHTyUmyDa2LlhcyJTkQByrJotY/qw4o=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  doCheck = false; # no tests

  pythonImportsCheck = [ "teslemetry_stream" ];

  meta = {
    changelog = "https://github.com/Teslemetry/python-teslemetry-stream/releases/tag/${src.tag}";
    description = "Python library for the Teslemetry Streaming API";
    homepage = "https://github.com/Teslemetry/python-teslemetry-stream";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
