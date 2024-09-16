{
  buildPythonPackage,
  explorerscript,
  fetchFromGitHub,
  setuptools,
  gobject-introspection,
  gtk3,
  gtksourceview4,
  importlib-metadata,
  lib,
  ndspy,
  nest-asyncio,
  pmdsky-debug-py,
  pycairo,
  pygobject3,
  pygtkspellcheck,
  pythonOlder,
  range-typed-integers,
  skytemple-files,
  skytemple-icons,
  skytemple-ssb-emulator,
  wrapGAppsHook3,
}:

buildPythonPackage rec {
  pname = "skytemple-ssb-debugger";
  version = "1.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = "skytemple-ssb-debugger";
    rev = version;
    hash = "sha256-S38Nw7FntacEdwdGu2d/zUKOsGostVy9+U2KPxlvI5Q=";
  };

  build-system = [ setuptools ];

  buildInputs = [
    gtk3
    gtksourceview4
  ];
  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];
  dependencies = [
    explorerscript
    ndspy
    nest-asyncio
    pmdsky-debug-py
    pycairo
    pygobject3
    pygtkspellcheck
    range-typed-integers
    skytemple-files
    skytemple-icons
    skytemple-ssb-emulator
  ] ++ lib.optionals (pythonOlder "3.10") [ importlib-metadata ];

  doCheck = false; # requires Pokémon Mystery Dungeon ROM
  pythonImportsCheck = [ "skytemple_ssb_debugger" ];

  meta = with lib; {
    homepage = "https://github.com/SkyTemple/skytemple-ssb-debugger";
    description = "Script Engine Debugger for Pokémon Mystery Dungeon Explorers of Sky";
    mainProgram = "skytemple-ssb-debugger";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ marius851000 ];
  };
}
