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
  version = "1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NTEafcAU/PU1/2n3pb3m8dbZptI9j9nnmVG4iFqHHe8=";
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
