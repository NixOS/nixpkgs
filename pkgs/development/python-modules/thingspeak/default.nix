{
  lib,
  buildPythonPackage,
  docopt,
  fetchFromGitHub,
  poetry-core,
  pytest-vcr,
  pytestCheckHook,
  requests,
  setuptools,
  vcrpy,
}:

buildPythonPackage rec {
  pname = "thingspeak";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mchwalisz";
    repo = "thingspeak";
    tag = "v${version}";
    hash = "sha256-9YvudzksWp130hkG8WxiX9WHegAVH2TT1vwMbLJ13qE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "poetry.masonry.api" "poetry.core.masonry.api" \
      --replace-fail 'requires = ["poetry>=0.12"]' 'requires = ["poetry-core"]'
  '';

  build-system = [
    poetry-core
  ];

  dependencies = [
    docopt
    requests
    setuptools
  ];

  nativeCheckInputs = [
    pytest-vcr
    pytestCheckHook
    vcrpy
  ];

  disabledTests = [
    # VCR cassette conflicts with different API keys
    "test_get_with_key"
  ];

  pythonImportsCheck = [
    "thingspeak"
  ];

  meta = {
    description = "Client library for the thingspeak.com API";
    homepage = "https://github.com/mchwalisz/thingspeak";
    changelog = "https://github.com/mchwalisz/thingspeak/releases/tag/v${version}";
    license = lib.licenses.lgpl3Only;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
