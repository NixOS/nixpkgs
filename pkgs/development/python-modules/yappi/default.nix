{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "yappi";
  version = "1.7.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sumerc";
    repo = "yappi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sY5USlhJiopKdnobsL47bcfzKY6bB3TpdmIhfjnKuis=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    export PYTHONPATH=$PYTHONPATH:$PWD/tests
    export PATH=$PATH:$out/bin
  '';

  pythonImportsCheck = [ "yappi" ];

  meta = {
    description = "Python profiler that supports multithreading and measuring CPU time";
    mainProgram = "yappi";
    changelog = "https://github.com/sumerc/yappi/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/sumerc/yappi";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
