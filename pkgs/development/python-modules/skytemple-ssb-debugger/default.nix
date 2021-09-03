{ lib, buildPythonPackage, fetchFromGitHub, gobject-introspection, gtk3, gtksourceview3
, wrapGAppsHook, nest-asyncio, pycairo, py-desmume, pygtkspellcheck, setuptools
, skytemple-files, skytemple-icons
}:

buildPythonPackage rec {
  pname = "skytemple-ssb-debugger";
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = pname;
    rev = version;
    sha256 = "0jkx75z8j03jfr9kzd40ip0fy24sfc7f2x430mf48xin272mc87q";
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
