{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytest,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "scripttest";
  version = "3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pypa";
    repo = "scripttest";
    tag = finalAttrs.version;
    hash = "sha256-2mM+d7ZudiqxRjqbOKR4mUiv1hdS+hm26sxu05yMY48=";
  };

  build-system = [ flit-core ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "scripttest" ];

  meta = {
    description = "Library for testing interactive command-line applications";
    homepage = "https://github.com/pypa/scripttest/";
    changelog = "https://github.com/pypa/scripttest/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
