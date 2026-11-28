{
  lib,
  buildPythonPackage,
  cffi,
  fetchPypi,
  pytestCheckHook,
  setuptools,
  libxcb,
  xeyes,
  xvfb,
}:

buildPythonPackage rec {
  pname = "xcffib";
  version = "1.13.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sbVTWqKEoN8wh8GhAb/abtnFClmvS5G6k9R6exfsCmU=";
  };

  postPatch = ''
    # Hardcode cairo library path
    substituteInPlace xcffib/__init__.py \
      --replace-fail "lib = ffi.dlopen(soname)" "lib = ffi.dlopen('${lib.getLib libxcb}/lib/' + soname)"
  '';

  build-system = [ setuptools ];

  propagatedNativeBuildInputs = [ cffi ];

  propagatedBuildInputs = [ cffi ];

  nativeCheckInputs = [
    pytestCheckHook
    xeyes
    xvfb
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
