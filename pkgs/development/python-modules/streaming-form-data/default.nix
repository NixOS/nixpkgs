{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  cython,
  setuptools,
  pytestCheckHook,
  requests-toolbelt,
}:

buildPythonPackage rec {
  pname = "streaming-form-data";
  version = "1.19.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "siddhantgoel";
    repo = "streaming-form-data";
    rev = "v${version}";
    hash = "sha256-3tK7dX5p1uH/azmFxzELM1bflGI/SHoLvsw+Ta+7rC4=";
  };

  # streaming-form-data has a small bit of code that uses smart_open, which has a massive closure.
  # The only consumer of streaming-form-data is Moonraker, which doesn't use that code.
  # So, just drop the dependency to not have to deal with it.
  patches = [ ./drop-smart-open.patch ];

  nativeBuildInputs = [
    cython
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-toolbelt
  ];

  enabledTestPaths = [ "tests" ];

  pythonImportsCheck = [ "streaming_form_data" ];

  preCheck = ''
    # remove in-tree copy to make pytest find the installed one, with the native parts already built
    rm -rf streaming_form_data
  '';

  meta = {
    description = "Streaming parser for multipart/form-data";
    homepage = "https://github.com/siddhantgoel/streaming-form-data";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zhaofengli ];
  };
}
