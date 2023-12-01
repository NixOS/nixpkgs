{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "djlint";
  version = "1.32.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Riverside-Healthcare";
    repo = "djlint";
    rev = "v${version}";
    hash = "sha256-///ZEkVohioloBJn6kxpEK5wmCzMp9ZYeAH1mONOA0E=";
  };

  nativeBuildInputs = [
    python3.pkgs.poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
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

  meta = with lib; {
    description = "HTML Template Linter and Formatter. Django - Jinja - Nunjucks - Handlebars - GoLang";
    homepage = "https://github.com/Riverside-Healthcare/djlint";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ traxys ];
  };
}
