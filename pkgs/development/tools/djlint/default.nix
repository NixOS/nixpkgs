{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "djlint";
  version = "1.34.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Riverside-Healthcare";
    repo = "djlint";
    rev = "refs/tags/v${version}";
    hash = "sha256-p9RIzX9zoZxBrhiNaIeCX9OgfQm/lXNwYsh6IcsnIVk=";
  };

  build-system = with python3.pkgs; [
    poetry-core
  ];

  pythonRelaxDeps = [
    "pathspec"
    "regex"
  ];

  dependencies = with python3.pkgs; [
    click
    colorama
    cssbeautifier
    html-tag-names
    html-void-elements
    jsbeautifier
    json5
    pathspec
    pyyaml
    regex
    tomli
    tqdm
  ];

  pythonImportsCheck = [ "djlint" ];

  meta = {
    description = "HTML Template Linter and Formatter. Django - Jinja - Nunjucks - Handlebars - GoLang";
    mainProgram = "djlint";
    homepage = "https://github.com/Riverside-Healthcare/djlint";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ traxys ];
  };
}
