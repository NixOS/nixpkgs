{ lib
, buildPythonPackage
, fetchPypi
, python
, cffi
, pkg-config
, libxkbcommon
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "xkbcommon";
  version = "0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "V5LMaX5TPhk9x4ZA4MGFzDhUiC6NKPo4uTbW6Q7mdVw=";
  };

  nativeBuildInputs = [ pkg-config ];
  propagatedNativeBuildInputs = [ cffi ];
  buildInputs = [ libxkbcommon ];
  propagatedBuildInputs = [ cffi ];
  checkInputs = [ pytestCheckHook ];

  postBuild = ''
    ${python.interpreter} xkbcommon/ffi_build.py
  '';

  pythonImportsCheck = [ "xkbcommon" ];

  meta = with lib; {
    homepage = "https://github.com/sde1000/python-xkbcommon";
    description = "Python bindings for libxkbcommon using cffi";
    license = licenses.mit;
    maintainers = with maintainers; [ chvp ];
  };
}
