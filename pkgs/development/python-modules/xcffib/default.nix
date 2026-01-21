{
  lib,
  buildPythonPackage,
  cffi,
  fetchPypi,
  pytestCheckHook,
  xorg,
}:

buildPythonPackage rec {
  pname = "xcffib";
  version = "1.12.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Q0Ut5QnBJk1bzqS8Alyhv2gnLSQO8m0zQLRuEfY9PUo=";
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

  meta = {
    description = "Drop in replacement for xpyb, an XCB python binding";
    homepage = "https://github.com/tych0/xcffib";
    changelog = "https://github.com/tych0/xcffib/releases/tag/v${version}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin ++ lib.platforms.windows;
    maintainers = with lib.maintainers; [ kamilchm ];
  };
}
