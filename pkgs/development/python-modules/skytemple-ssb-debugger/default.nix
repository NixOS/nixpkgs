{ lib, buildPythonPackage, fetchFromGitHub, gobject-introspection, gtk3, gtksourceview3
, wrapGAppsHook, nest-asyncio, pycairo, py-desmume, pygtkspellcheck, setuptools
, skytemple-files, skytemple-icons
}:

buildPythonPackage rec {
  pname = "skytemple-ssb-debugger";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = pname;
    rev = version;
    sha256 = "0jmsli3wg386y0lxwddpwp1xqxsn2bsy4d1f7dyh0jjz8lqiz03i";
  };

  buildInputs = [ gobject-introspection gtk3 gtksourceview3 ];
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
