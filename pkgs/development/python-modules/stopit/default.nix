{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,

}:

buildPythonPackage (finalAttrs: {
  pname = "stopit";
  version = "1.1.2";
  pyproject = true;
  __structuredAttrs = true;

  # tests are missing from the PyPi tarball
  src = fetchFromGitHub {
    owner = "glenfant";
    repo = "stopit";
    tag = finalAttrs.version;
    hash = "sha256-uXJUA70JOGWT2NmS6S7fPrTWAJZ0mZ/hICahIUzjfbw=";
  };

  build-system = [
    setuptools # for pkg_resources
  ];

  patches = [
    # https://github.com/glenfant/stopit/pull/34
    ./import_lib.patch
  ];

  pythonImportsCheck = [ "stopit" ];

  meta = {
    broken = lib.versionAtLeast setuptools.version "82";
    description = "Raise asynchronous exceptions in other thread, control the timeout of blocks or callables with a context manager or a decorator";
    homepage = "https://github.com/glenfant/stopit";
    changelog = "https://github.com/glenfant/stopit/blob/${finalAttrs.version}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ veprbl ];
  };
})
