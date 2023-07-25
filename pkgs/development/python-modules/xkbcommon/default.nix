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
  version = "0.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-W+WXO/W3UlaHpN9shHibQhWQ1/fPkq5W8qqxd7eV1RY=";
  };

  nativeBuildInputs = [ pkg-config ];
  propagatedNativeBuildInputs = [ cffi ];
  buildInputs = [ libxkbcommon ];
  propagatedBuildInputs = [ cffi ];
  nativeCheckInputs = [ pytestCheckHook ];

  postBuild = ''
    ${python.pythonForBuild.interpreter} xkbcommon/ffi_build.py
  '';

  pythonImportsCheck = [ "xkbcommon" ];

  meta = with lib; {
    homepage = "https://github.com/sde1000/python-xkbcommon";
    description = "Python bindings for libxkbcommon using cffi";
    license = licenses.mit;
    maintainers = with maintainers; [ chvp ];
  };
}
