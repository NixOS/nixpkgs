{
  lib,
  buildPythonPackage,
  fetchPypi,
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
  version = "0.16.0";
  format = "pyproject";

  src = fetchPypi {
    pname = "ufoLib2";
    inherit version;
    hash = "sha256-SfDcf3LMrP5/rv4NU9N5cdRWZNiwVj7zaVb6e/pVor0=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    attrs
    fonttools
  ] ++ fonttools.optional-dependencies.ufo;

  passthru.optional-dependencies = {
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
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [ "ufoLib2" ];

  meta = with lib; {
    description = "Library to deal with UFO font sources";
    homepage = "https://github.com/fonttools/ufoLib2";
    license = licenses.mit;
    maintainers = [ ];
  };
}
