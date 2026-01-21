{
  lib,
  buildPythonPackage,
  colorama,
  fetchFromGitHub,
  pytestCheckHook,
  regex,
  setuptools,
}:

buildPythonPackage rec {
  pname = "tatsu";
  version = "5.16.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "neogeny";
    repo = "TatSu";
    tag = "v${version}";
    hash = "sha256-YFNoA81J8x4OO7lLUjeN/NzQfCTEeosaWZg9UKy8C50=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    colorama
    regex
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "tatsu" ];

  meta = {
    description = "Generates Python parsers from grammars in a variation of EBNF";
    longDescription = ''
      TatSu (the successor to Grako) is a tool that takes grammars in a
      variation of EBNF as input, and outputs memoizing (Packrat) PEG parsers in
      Python.
    '';
    homepage = "https://tatsu.readthedocs.io/";
    changelog = "https://github.com/neogeny/TatSu/releases/tag/${src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}
