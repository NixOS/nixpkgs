{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "zope-contenttype";
  version = "5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.contenttype";
    tag = version;
    hash = "sha256-mY6LlJn44hUfXpxEa99U6FNcsV9xJbR5w/iIS6hG+m4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools <= 75.6.0" setuptools
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "zope.contenttype" ];

  pythonNamespaces = [ "zope" ];

  meta = {
    homepage = "https://github.com/zopefoundation/zope.contenttype";
    description = "Utility module for content-type (MIME type) handling";
    changelog = "https://github.com/zopefoundation/zope.contenttype/blob/${version}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = [ ];
  };
}
