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
  version = "5.13.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dnicolodi";
    repo = "TatSu-LTS";
    tag = "v${version}-LTS";
    hash = "sha256-cfGAWZDAnoD3ddhVIkOHyiv7gUDgnAWu1ZBvDEiQ2AQ=";
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
