{ lib
, buildPythonPackage
, fetchPypi
, attrs
, fonttools
, pytestCheckHook
, setuptools-scm

# optionals
, cattrs
, lxml
, orjson
, msgpack
}:

buildPythonPackage rec {
  pname = "ufoLib2";
  version = "0.14.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OdUJfNe3nOQyCf3nT9/5y/C8vZXnSAWiLHvZ8GXMViw=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    attrs
    fonttools
  ] ++ fonttools.optional-dependencies.ufo;

  passthru.optional-dependencies = {
    lxml = [ lxml ];
    converters = [ cattrs ];
    json = [ cattrs orjson ];
    msgpack = [ cattrs msgpack ];
  };

  checkInputs = [
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [ "ufoLib2" ];

  meta = with lib; {
    description = "Library to deal with UFO font sources";
    homepage = "https://github.com/fonttools/ufoLib2";
    license = licenses.mit;
    maintainers = with maintainers; [ jtojnar ];
  };
}
