{
  beautifulsoup4,
  buildPythonPackage,
  colorama,
  fetchPypi,
  lib,
  pillow,
  pymongo,
  pyotp,
  readerwriterlock,
  redis,
  requests,
  setuptools,
  tls-client,
  typing-extensions,
  validators,
  websockets,
}:

buildPythonPackage (finalAttrs: {
  pname = "spotapi";
  version = "1.2.7";
  pyproject = true;

  # no tags on GitHub
  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-x4UA65A4UvxqlDN5upHsPPa5yv8gKZw3kqLou/1xVtY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    beautifulsoup4
    colorama
    pillow
    pyotp
    readerwriterlock
    requests
    tls-client
    typing-extensions
    validators
  ]
  # optional dependencies are always imported
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  optional-dependencies = {
    pymongo = [ pymongo ];
    redis = [ redis ];
    websocket = [ websockets ];
  };

  pythonImportsCheck = [ "spotapi" ];

  # upstream has no unit tests
  doCheck = false;

  meta = {
    description = "Python wrapper for the public & private Spotify API";
    homepage = "https://github.com/Aran404/SpotAPI";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
