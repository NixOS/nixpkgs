{ lib
, buildPythonPackage
, fetchFromGitHub
, gobject-introspection
, gtk3
, gtksourceview4
, wrapGAppsHook
, nest-asyncio
, pycairo
, py-desmume
, pygtkspellcheck
, setuptools
, skytemple-files
, skytemple-icons
}:

buildPythonPackage rec {
  pname = "skytemple-ssb-debugger";
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = pname;
    rev = version;
    hash = "sha256-/LBz0PCQI3QOAmOZk6Jynqi/+NN0w8gbY/S3YckRZ68=";
  };

  buildInputs = [ gobject-introspection gtk3 gtksourceview4 ];
  nativeBuildInputs = [ gobject-introspection wrapGAppsHook ];
  propagatedBuildInputs = [
    nest-asyncio
    pycairo
    py-desmume
    pygtkspellcheck
    setuptools
    skytemple-files
    skytemple-icons
  ];

  doCheck = false; # requires Pokémon Mystery Dungeon ROM
  pythonImportsCheck = [ "skytemple_ssb_debugger" ];

  meta = with lib; {
    homepage = "https://github.com/SkyTemple/skytemple-ssb-debugger";
    description = "Script Engine Debugger for Pokémon Mystery Dungeon Explorers of Sky";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ xfix ];
  };
}
