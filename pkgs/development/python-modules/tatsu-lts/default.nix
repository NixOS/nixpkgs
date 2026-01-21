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
  pname = "tatsu-lts";
  version = "5.16.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dnicolodi";
    repo = "TatSu-LTS";
    tag = "v${version}";
    hash = "sha256-YFNoA81J8x4OO7lLUjeN/NzQfCTEeosaWZg9UKy8C50=";
  };

  build-system = [ setuptools ];

  dependencies = [
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
    changelog = "https://github.com/dnicolodi/TatSu-LTS/releases/tag/${src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ alapshin ];
  };
}
