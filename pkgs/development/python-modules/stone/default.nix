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
  version = "3.5.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dropbox";
    repo = "stone";
    tag = "v${finalAttrs.version}";
    hash = "sha256-79CY4eJcsMrhJvRCdD3brwmPkl8kxLQbGIqxIA9UXPg=";
  };

  postPatch = ''
    # https://github.com/dropbox/stone/pull/373 pins setuptools-scm to <9,
    # but that version is not in nixpkgs and it seems to work anyway?
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools-scm>=8,<9" "setuptools-scm"
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
