{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  jinja2,
  mock,
  packaging,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "stone";
  version = "3.5.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dropbox";
    repo = "stone";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Cq3RjyXazsWMrQV1p6Rmx5k7ioC7yxrDm8LYwXarhLc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools>=84.0.0", "setuptools-scm>=10.2.1,<11"' '"setuptools", "setuptools-scm"'
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    jinja2
    packaging
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
  ];

  pythonImportsCheck = [ "stone" ];

  meta = {
    description = "Official API Spec Language for Dropbox API V2";
    homepage = "https://github.com/dropbox/stone";
    changelog = "https://github.com/dropbox/stone/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "stone";
  };
})
