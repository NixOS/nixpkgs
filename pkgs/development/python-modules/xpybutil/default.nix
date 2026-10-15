{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  xcffib,
  pillow,
}:

buildPythonPackage (finalAttrs: {
  pname = "xpybutil";
  version = "0.0.6";
  pyproject = true;

  __structuredAttrs = true;

  # Pypi only offers a wheel
  src = fetchFromGitHub {
    owner = "BurntSushi";
    repo = "xpybutil";
    tag = finalAttrs.version;
    hash = "sha256-73bAQaGjI5w+Xb3t+ToDhn1FQgcUWa9UEpS5UhLG650=";
  };

  build-system = [ setuptools ];

  # pillow is a dependency in image.py which is not listed in setup.py
  dependencies = [
    pillow
    xcffib
  ];

  propagatedNativeBuildInputs = [ xcffib ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "xpybutil" ];

  meta = {
    homepage = "https://github.com/BurntSushi/xpybutil";
    description = "Incomplete xcb-util port plus some extras";
    license = lib.licenses.wtfpl;
    maintainers = with lib.maintainers; [ artturin ];
  };
})
