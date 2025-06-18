{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "zope-hookable";
  version = "7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.hookable";
    tag = version;
    hash = "sha256-qJJc646VSdNKors6Au4UAGvm7seFbvjEfpdqf//vJNE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools<74" "setuptools"
  '';

  build-system = [ setuptools ];

  pythonImportsCheck = [ "zope.hookable" ];

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [ "src/zope/hookable/tests" ];

  pythonNamespaces = [ "zope" ];

  meta = with lib; {
    description = "Supports the efficient creation of “hookable” objects";
    homepage = "https://github.com/zopefoundation/zope.hookable";
    changelog = "https://github.com/zopefoundation/zope.hookable/blob/${src.tag}/CHANGES.rst";
    license = licenses.zpl21;
  };
}
