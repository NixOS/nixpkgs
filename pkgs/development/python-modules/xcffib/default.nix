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
  version = "1.9.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-K6xgY2lnVOiHHC9AcwR7Uz792Cx33fhnYgEWcJfMUlM=";
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
    xorg.xvfb
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
