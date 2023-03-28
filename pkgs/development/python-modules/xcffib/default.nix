{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, xorg
, cffi
, pytestCheckHook
}:

buildPythonPackage rec {
  version = "1.2.0";
  pname = "xcffib";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8yMCFEf55zB40hu5KMSPTavq6z87N+gDxta5hzXoFIM=";
  };

  patches = [
    (fetchpatch {
      name = "remove-leftover-six-import.patch";
      url = "https://github.com/tych0/xcffib/commit/8a488867d30464913706376ca3a9f4c98ca6c5cf.patch";
      hash = "sha256-wEms0gC7tVqtmKMjjpH/34kdQ6HUV0h67bUGbgijlqw=";
    })
  ];

  postPatch = ''
    # Hardcode cairo library path
    sed -e 's,ffi\.dlopen(,&"${xorg.libxcb.out}/lib/" + ,' -i xcffib/__init__.py
  '';

  propagatedBuildInputs = [ cffi ];

  propagatedNativeBuildInputs = [ cffi ];

  nativeCheckInputs = [
    pytestCheckHook
    xorg.xeyes
    xorg.xorgserver
  ];

  preCheck = ''
    # import from $out
    rm -r xcffib
  '';

  pythonImportsCheck = [ "xcffib" ];

  meta = with lib; {
    description = "A drop in replacement for xpyb, an XCB python binding";
    homepage = "https://github.com/tych0/xcffib";
    license = licenses.asl20;
    maintainers = with maintainers; [ kamilchm ];
  };
}
