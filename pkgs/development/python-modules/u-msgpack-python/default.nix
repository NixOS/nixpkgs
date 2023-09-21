{ buildPythonPackage
, lib
, fetchPypi
, glibcLocales
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "u-msgpack-python";
  version = "2.8.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uAGoPW7XXm30HkRRi08qnCIdwtpLzVOA46D+2lILxho=";
  };

  env.LC_ALL="en_US.UTF-8";

  buildInputs = [ glibcLocales ];

  nativeCheckInputs = [ unittestCheckHook ];

  meta = {
    description = "A portable, lightweight MessagePack serializer and deserializer written in pure Python";
    homepage = "https://github.com/vsergeev/u-msgpack-python";
    changelog = "https://github.com/vsergeev/u-msgpack-python/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
  };
}
