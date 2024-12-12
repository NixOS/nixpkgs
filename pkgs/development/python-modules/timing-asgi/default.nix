{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "timing-asgi";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "steinnes";
    repo = "timing-asgi";
    rev = "refs/tags/v${version}";
    hash = "sha256-oEDesmy9t2m51Zd6Zg87qoYbfbDnejfrbjyBkZ3hF58=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
    --replace-fail poetry.masonry.api poetry.core.masonry.api \
    --replace-fail "poetry>=" "poetry-core>="
  '';

  build-system = [ poetry-core ];

  pythonImportsCheck = [ "timing_asgi" ];

  # Tests rely on asynctest which is not supported by python 3.11
  doCheck = false;

  nativeCheckInputs = [
    # asynctest-0.13.0 not supported for interpreter python3.11
    # asynctest
    pytestCheckHook
  ];

  meta = with lib; {
    description = "ASGI middleware to emit timing metrics with something like statsd";
    homepage = "https://pypi.org/project/timing-asgi";
    license = licenses.mit;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
