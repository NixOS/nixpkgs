{
  lib,
  python3Packages,
  fetchFromGitHub,
  beets,
  beetsPackages,
}:

python3Packages.buildPythonApplication rec {
  pname = "beets-audible";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Neurrone";
    repo = "beets-audible";
    rev = "v${version}";
    hash = "sha256-m955KPtYfjmtm9kHhkZLWoMYzVq0THOwvKCJYiVna7k=";
  };

  build-system = with python3Packages; [ hatchling ];

  dependencies = with python3Packages; [
    beets
    beetsPackages.copyartifacts
    markdownify
    natsort
    tldextract
  ];

  pythonImportsCheck = [
    "beetsplug.api"
    "beetsplug.audible"
    "beetsplug.book"
    "beetsplug.goodreads"
  ];

  meta = {
    description = "Beets plugin to manage audiobook collections";
    homepage = "https://github.com/Neurrone/beets-audible";
    changelog = "https://github.com/Neurrone/beets-audible/blob/v${version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ dansbandit ];
    license = lib.licenses.mit;
    inherit (beets.meta) platforms;
  };
}
