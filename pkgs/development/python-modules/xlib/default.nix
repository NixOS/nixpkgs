{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  six,
  setuptools,
  setuptools-scm,
  libx11,
  xvfb,
  xauth,
  mock,
  pytestCheckHook,
  util-linux,
}:

buildPythonPackage rec {
  pname = "xlib";
  version = "0.33";
  pyproject = true;

  build-system = [ setuptools ];

  src = fetchFromGitHub {
    owner = "python-xlib";
    repo = "python-xlib";
    tag = version;
    hash = "sha256-u06OWlMIOUzHOVS4hvm72jGgTSXWUqMvEQd8bTpFog0=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  buildInputs = [ libx11 ];

  propagatedBuildInputs = [ six ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  nativeCheckInputs = [
    pytestCheckHook
    mock
    util-linux
    xauth
    xvfb
  ];

  disabledTestPaths = [
    # requires x session
    "test/test_xlib_display.py"
  ];

  meta = {
    changelog = "https://github.com/python-xlib/python-xlib/releases/tag/${version}";
    description = "Fully functional X client library for Python programs";
    homepage = "https://github.com/python-xlib/python-xlib";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ ];
  };
}
