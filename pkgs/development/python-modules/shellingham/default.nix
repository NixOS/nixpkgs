{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  procps,
  setuptools,
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "shellingham";
  version = "1.5.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sarugaku";
    repo = "shellingham";
    tag = finalAttrs.version;
    hash = "sha256-xeBo3Ok+XPrHN4nQd7M8/11leSV/8z1f7Sj33+HFVtQ=";
  };

  postPatch = ''
    substituteInPlace src/shellingham/posix/ps.py \
      --replace-fail \
        'cmd = ["ps",' \
        'cmd = ["${lib.getExe' procps "ps"}",'
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "shellingham" ];

  meta = {
    description = "Tool to detect the surrounding shell";
    homepage = "https://github.com/sarugaku/shellingham";
    changelog = "https://github.com/sarugaku/shellingham/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ mbode ];
  };
})
