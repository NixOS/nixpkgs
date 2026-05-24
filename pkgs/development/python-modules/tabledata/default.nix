{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools-scm,
  dataproperty,
  typepy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "tabledata";
  version = "1.3.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = "tabledata";
    tag = "v${version}";
    hash = "sha256-yt71e2ZPJ5WpDLs6sU4kYQGR13IgJB7gMEzhaCHblos=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    dataproperty
    typepy
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    homepage = "https://github.com/thombashi/tabledata";
    description = "Library to represent tabular data";
    changelog = "https://github.com/thombashi/tabledata/releases/tag/${src.tag}";
    maintainers = [ ];
    license = lib.licenses.mit;
  };
}
