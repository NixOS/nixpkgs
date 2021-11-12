{ lib, buildPythonPackage, fetchFromGitHub, appdirs, dungeon-eos, explorerscript
, ndspy, pillow, setuptools, skytemple-rust, tilequant, armips
}:

buildPythonPackage rec {
  pname = "skytemple-files";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = pname;
    rev = version;
    sha256 = "01j6khn60mdmz32xkpqrzwdqibmpdpi2wvwzxgdnaim9sq0fdqws";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace skytemple_files/patch/arm_patcher.py \
      --replace "exec_name = os.getenv('SKYTEMPLE_ARMIPS_EXEC', f'{prefix}armips')" "exec_name = \"${armips}/bin/armips\""
  '';

  buildInputs = [ armips ];

  propagatedBuildInputs = [ appdirs dungeon-eos explorerscript ndspy pillow setuptools skytemple-rust tilequant ];

  doCheck = false; # requires Pokémon Mystery Dungeon ROM
  pythonImportsCheck = [ "skytemple_files" ];

  meta = with lib; {
    homepage = "https://github.com/SkyTemple/skytemple-files";
    description = "Python library to edit the ROM of Pokémon Mystery Dungeon Explorers of Sky";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ xfix marius851000 ];
  };
}
