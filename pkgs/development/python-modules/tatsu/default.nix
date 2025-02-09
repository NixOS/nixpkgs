{
  lib,
  buildPythonPackage,
  colorama,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  regex,
  setuptools,
}:

buildPythonPackage rec {
  pname = "tatsu";
  version = "5.13.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "neogeny";
    repo = "TatSu";
    tag = "v${version}";
    hash = "sha256-iZtYqPvQxXl6SFG2An7dN3KxaxCTvAiAkeeuXUhLuF0=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    colorama
    regex
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "tatsu" ];

  meta = with lib; {
    description = "Generates Python parsers from grammars in a variation of EBNF";
    longDescription = ''
      TatSu (the successor to Grako) is a tool that takes grammars in a
      variation of EBNF as input, and outputs memoizing (Packrat) PEG parsers in
      Python.
    '';
    homepage = "https://tatsu.readthedocs.io/";
    changelog = "https://github.com/neogeny/TatSu/releases/tag/${src.tag}";
    license = licenses.bsd2;
    maintainers = [ ];
  };
}
