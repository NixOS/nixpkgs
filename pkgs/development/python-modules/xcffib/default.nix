{
  lib,
  buildPythonPackage,
  isPyPy,
  setuptools,
  cffi,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  xorg,
}:

buildPythonPackage rec {
  pname = "xcffib";
  version = "1.7.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-M3dcHQRh8ZJV/FTiLOkU4QoT+2W8e7oOq6/ufwh4z9s=";
  };

  postPatch = ''
    # Hardcode cairo library path
    sed -e 's,ffi\.dlopen(,&"${xorg.libxcb.out}/lib/" + ,' -i xcffib/__init__.py
  '';

  build-system = [ setuptools ];

  dependencies = lib.optionals (!isPyPy) [ cffi ];

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

  meta = {
    description = "Drop in replacement for xpyb, an XCB python binding";
    homepage = "https://github.com/tych0/xcffib";
    changelog = "https://github.com/tych0/xcffib/releases/tag/v${version}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin ++ lib.platforms.windows;
    maintainers = with lib.maintainers; [ kamilchm ];
  };
}
