{ lib, buildPythonPackage, fetchFromGitHub, appdirs, explorerscript, ndspy, pillow, setuptools, skytemple-rust, tilequant }:

buildPythonPackage rec {
  pname = "skytemple-files";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = pname;
    rev = version;
    sha256 = "1vklg4kcj3kb9ryrzrcmywn131b2bp3vy94cd4x4y4s7hkhgwg74";
  };

  propagatedBuildInputs = [ appdirs explorerscript ndspy pillow setuptools skytemple-rust tilequant ];

  doCheck = false; # requires Pokémon Mystery Dungeon ROM
  pythonImportsCheck = [ "skytemple_files" ];

  meta = with lib; {
    homepage = "https://github.com/SkyTemple/skytemple-files";
    description = "Python library to edit the ROM of Pokémon Mystery Dungeon Explorers of Sky";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ xfix ];
  };
}
