{
  lib,
  buildPythonPackage,
  fetchPypi,
  uncompyle6,
}:

buildPythonPackage (finalAttrs: {
  pname = "unrpa";
  version = "2.3.0";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-RBxdEpwYpcdYOSe8QuP3UeTxcaMWo6QnOMHGcXnDhHo=";
  };

  optional-dependencies = {
    ZiX = [ uncompyle6 ];
  };

  pythonImportsCheck = [ "unrpa" ];

  # upstream has no unit tests
  doCheck = false;

  meta = {
    homepage = "https://github.com/Lattyware/unrpa";
    changelog = "https://github.com/Lattyware/unrpa/releases/tag/${finalAttrs.version}";
    description = "Program to extract files from the RPA archive format";
    mainProgram = "unrpa";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ leo60228 ];
  };
})
