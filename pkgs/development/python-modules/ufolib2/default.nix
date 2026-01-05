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
  version = "0.18.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "fonttools";
    repo = "ufoLib2";
    tag = "v${version}";
    hash = "sha256-YFGgPpiEurPaTUFaSMsVBKS4Ob+vPyZhputfRE39wtg=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    attrs
    fonttools
  ]
  ++ fonttools.optional-dependencies.ufo;

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
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "ufoLib2" ];

  meta = with lib; {
    changelog = "https://github.com/fonttools/ufoLib2/releases/tag/${src.tag}";
    description = "Library to deal with UFO font sources";
    homepage = "https://github.com/fonttools/ufoLib2";
    license = licenses.mit;
    maintainers = [ ];
  };
}
