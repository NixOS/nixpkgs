{
  beets,
  fetchFromGitHub,
  lib,
  nix-update-script,
  python3Packages,
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

  pythonRelaxDeps = true;

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies =
    [ beets ]
    ++ (with python3Packages; [
      markdownify
      natsort
      tldextract
    ]);

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Beets-audible: Organize Your Audiobook Collection With Beets";
    homepage = "https://github.com/Neurrone/beets-audible";
    platforms = with lib.platforms; linux ++ darwin ++ windows;
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ jwillikers ];
  };
}
