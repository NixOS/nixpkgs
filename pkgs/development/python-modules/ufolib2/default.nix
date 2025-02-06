{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  attrs,
  fonttools,
  pytestCheckHook,
  setuptools-scm,

  # optionals
  cattrs,
  lxml,
  orjson,
  msgpack,
}:

buildPythonPackage rec {
  pname = "ufolib2";
  version = "0.17.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "fonttools";
    repo = "ufoLib2";
    tag = "v${version}";
    hash = "sha256-WSy+5tH+/ThbmfOC5KiTzCagcLSiXZXPuiIEJZ07KK0=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    attrs
    fonttools
  ] ++ fonttools.optional-dependencies.ufo;

  optional-dependencies = {
    lxml = [ lxml ];
    converters = [ cattrs ];
    json = [
      cattrs
      orjson
    ];
    msgpack = [
      cattrs
      msgpack
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  pythonImportsCheck = [ "ufoLib2" ];

  meta = with lib; {
    changelog = "https://github.com/fonttools/ufoLib2/releases/tag/${src.tag}";
    description = "Library to deal with UFO font sources";
    homepage = "https://github.com/fonttools/ufoLib2";
    license = licenses.mit;
    maintainers = [ ];
  };
}
