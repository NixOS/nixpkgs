{ buildPythonPackage
, lib
, fetchPypi
, glibcLocales
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "u-msgpack-python";
<<<<<<< HEAD
  version = "2.8.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uAGoPW7XXm30HkRRi08qnCIdwtpLzVOA46D+2lILxho=";
  };

  env.LC_ALL="en_US.UTF-8";
=======
  version = "2.7.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6G96xqoO9MbEnwBLT9Q1vOmcI+LdXXMAPz+YFgJMK9g=";
  };

  LC_ALL="en_US.UTF-8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = [ glibcLocales ];

  nativeCheckInputs = [ unittestCheckHook ];

  meta = {
    description = "A portable, lightweight MessagePack serializer and deserializer written in pure Python";
    homepage = "https://github.com/vsergeev/u-msgpack-python";
<<<<<<< HEAD
    changelog = "https://github.com/vsergeev/u-msgpack-python/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
  };
=======
    license = lib.licenses.mit;
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
