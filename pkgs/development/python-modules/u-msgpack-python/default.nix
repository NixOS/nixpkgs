{ buildPythonPackage
, lib
, fetchPypi
, glibcLocales
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "u-msgpack-python";
  version = "2.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-6G96xqoO9MbEnwBLT9Q1vOmcI+LdXXMAPz+YFgJMK9g=";
  };

  LC_ALL="en_US.UTF-8";

  buildInputs = [ glibcLocales ];

  checkInputs = [ unittestCheckHook ];

  meta = {
    description = "A portable, lightweight MessagePack serializer and deserializer written in pure Python";
    homepage = "https://github.com/vsergeev/u-msgpack-python";
    license = lib.licenses.mit;
  };

}
