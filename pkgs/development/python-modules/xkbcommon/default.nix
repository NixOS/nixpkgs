{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
  setuptools,
  cffi,
  pkg-config,
  libxkbcommon,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "xkbcommon";
  version = "1.5.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-rBdICNv2HTXZ2oBL8zuqx0vG8r4MEIWUrpPHnNFd3DY=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ pkg-config ];
  propagatedNativeBuildInputs = [ cffi ];
  buildInputs = [ libxkbcommon ];
  dependencies = [ cffi ];
  nativeCheckInputs = [ pytestCheckHook ];

  postBuild = ''
    ${python.pythonOnBuildForHost.interpreter} xkbcommon/ffi_build.py
  '';

  pythonImportsCheck = [ "xkbcommon" ];

  meta = {
    homepage = "https://github.com/sde1000/python-xkbcommon";
    description = "Python bindings for libxkbcommon using cffi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      chvp
      doronbehar
    ];
  };
})
