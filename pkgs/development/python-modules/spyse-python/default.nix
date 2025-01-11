{
  lib,
  buildPythonPackage,
  dataclasses-json,
  fetchFromGitHub,
  fetchpatch,
  limiter,
  pythonOlder,
  requests,
  responses,
  setuptools,
}:

buildPythonPackage rec {
  pname = "spyse-python";
  version = "2.2.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "spyse-com";
    repo = "spyse-python";
    tag = "v${version}";
    hash = "sha256-c7BAJOplWNcd9v7FrEZuMHHdMpqtHljF7YpbdQYAMxA=";
  };

  patches = [
    # Update limiter import and rate limit, https://github.com/spyse-com/spyse-python/pull/11
    (fetchpatch {
      name = "support-later-limiter.patch";
      url = "https://github.com/spyse-com/spyse-python/commit/ff68164c514dfb28ab77d8690b3a5153962dbe8c.patch";
      hash = "sha256-PoWPJCK/Scsh4P7lr97u4JpVHXNlY0C9rJgY4TDYmv0=";
    })
  ];

  pythonRemoveDeps = [ "dataclasses" ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "dataclasses-json~=0.5.4" "dataclasses-json>=0.5.4" \
      --replace-fail "responses~=0.13.3" "responses>=0.13.3" \
      --replace-fail "limiter~=0.1.2" "limiter>=0.1.2" \
      --replace-fail "requests~=2.26.0" "requests>=2.26.0"
  '';

  build-system = [ setuptools ];

  dependencies = [
    requests
    dataclasses-json
    responses
    limiter
  ];

  # Tests requires an API token
  doCheck = false;

  pythonImportsCheck = [ "spyse" ];

  meta = with lib; {
    description = "Python module for spyse.com API";
    homepage = "https://github.com/spyse-com/spyse-python";
    changelog = "https://github.com/spyse-com/spyse-python/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
