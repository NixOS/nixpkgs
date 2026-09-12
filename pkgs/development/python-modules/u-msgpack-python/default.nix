{
  buildPythonPackage,
  lib,
  fetchPypi,
  setuptools,
  glibcLocales,
  unittestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "u-msgpack-python";
  version = "2.8.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-uAGoPW7XXm30HkRRi08qnCIdwtpLzVOA46D+2lILxho=";
  };

  build-system = [ setuptools ];

  env.LC_ALL = "en_US.UTF-8";

  nativeCheckInputs = [
    glibcLocales
    unittestCheckHook
  ];

  pythonImportsCheck = [ "umsgpack" ];

  meta = {
    description = "Portable, lightweight MessagePack serializer and deserializer written in pure Python";
    homepage = "https://github.com/vsergeev/u-msgpack-python";
    changelog = "https://github.com/vsergeev/u-msgpack-python/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
  };
})
