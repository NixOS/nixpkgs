{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
  cffi,
  pkg-config,
  libxkbcommon,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "xkbcommon";
  version = "1.5.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rBdICNv2HTXZ2oBL8zuqx0vG8r4MEIWUrpPHnNFd3DY=";
  };

  nativeBuildInputs = [ pkg-config ];
  propagatedNativeBuildInputs = [ cffi ];
  buildInputs = [ libxkbcommon ];
  propagatedBuildInputs = [ cffi ];
  nativeCheckInputs = [ pytestCheckHook ];

  postBuild = ''
    ${python.pythonOnBuildForHost.interpreter} xkbcommon/ffi_build.py
  '';

  pythonImportsCheck = [ "xkbcommon" ];

  meta = with lib; {
    homepage = "https://github.com/sde1000/python-xkbcommon";
    description = "Python bindings for libxkbcommon using cffi";
    license = licenses.mit;
    maintainers = with maintainers; [ chvp ];
  };
}
