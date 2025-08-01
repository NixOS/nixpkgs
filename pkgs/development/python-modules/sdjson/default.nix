{
  buildPythonPackage,
  domdf-python-tools,
  fetchFromGitHub,
  lib,
  typing-extensions,
  whey,
}:

buildPythonPackage rec {
  pname = "sdjson";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "domdfcoding";
    repo = "singledispatch-json";
    tag = "v${version}";
    hash = "sha256-7qwmPhij2X2GLtjeaoMCoOyT0qzYt9oFccWrQOq6LXw=";
  };

  build-system = [ whey ];

  dependencies = [
    domdf-python-tools
    typing-extensions
  ];

  pythonImportsCheck = [ "sdjson" ];

  # missing dependency coincidence
  doCheck = false;

  meta = {
    description = "Custom JSON Encoder for Python utilising functools.singledispatch";
    homepage = "https://github.com/domdfcoding/singledispatch-json";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
