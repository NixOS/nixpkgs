{
  lib,
  buildPythonPackage,
  cffi,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  xorg,
}:

buildPythonPackage rec {
  pname = "xcffib";
  version = "1.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qVyUZfL5e0/O3mBr0eCEB6Mt9xy3YP1Xv+U2d9tpGsw=";
  };

  postPatch = ''
    # Hardcode cairo library path
    sed -e 's,ffi\.dlopen(,&"${xorg.libxcb.out}/lib/" + ,' -i xcffib/__init__.py
  '';

  propagatedNativeBuildInputs = [ cffi ];

  propagatedBuildInputs = [ cffi ];

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

  # Tests use xvfb
  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Drop in replacement for xpyb, an XCB python binding";
    homepage = "https://github.com/tych0/xcffib";
    changelog = "https://github.com/tych0/xcffib/releases/tag/v${version}";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin ++ platforms.windows;
    maintainers = with maintainers; [ kamilchm ];
  };
}
