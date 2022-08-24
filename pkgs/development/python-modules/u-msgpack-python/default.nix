{ buildPythonPackage
, lib
, fetchPypi
, glibcLocales
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "u-msgpack-python";
  version = "2.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b7e7d433cab77171a4c752875d91836f3040306bab5063fb6dbe11f64ea69551";
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
