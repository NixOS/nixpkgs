{ lib
, buildPythonPackage
, fetchPypi
, xorg
, cffi
, six
, pytestCheckHook
}:

buildPythonPackage rec {
  version = "1.1.2";
  pname = "xcffib";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Wqc6wlUUUpfMeJmhEFmEf41TDz2zhLPeOqwT+GDgS6w=";
  };

  patchPhase = ''
    # Hardcode cairo library path
    sed -e 's,ffi\.dlopen(,&"${xorg.libxcb.out}/lib/" + ,' -i xcffib/__init__.py
  '';

  propagatedBuildInputs = [ cffi six ];

  propagatedNativeBuildInputs = [ cffi ];

  checkInputs = [
    pytestCheckHook
    xorg.xeyes
    xorg.xorgserver
  ];

  pythonImportsCheck = [ "xcffib" ];

  meta = with lib; {
    description = "A drop in replacement for xpyb, an XCB python binding";
    homepage = "https://github.com/tych0/xcffib";
    license = licenses.asl20;
    maintainers = with maintainers; [ kamilchm ];
  };
}
