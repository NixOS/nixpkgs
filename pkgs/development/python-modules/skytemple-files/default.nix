{ lib, buildPythonPackage, fetchFromGitHub, appdirs, explorerscript, ndspy, pillow, setuptools, skytemple-rust, tilequant, armips, fetchpatch }:

buildPythonPackage rec {
  pname = "skytemple-files";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = pname;
    rev = version;
    sha256 = "1i3045bqg9h7kcx83nlrm1pmikfpi817n0gb8da29m3mqzk7lwws";
    fetchSubmodules = true;
  };

  patches = [
    # fix patching https://github.com/SkyTemple/skytemple-files/pull/128
    # merged, remove for next update
    (fetchpatch {
      url = "http://github.com/SkyTemple/skytemple-files/commit/71dd71e6abb7435405e30225e8a37592b990d692.patch";
      sha256 = "sha256-CSBaT+LVP9J0C1FlUCduTJroq9z2EAJG6lruvlHlQLI=";
    })
  ];

  postPatch = ''
    substituteInPlace skytemple_files/patch/arm_patcher.py \
      --replace "exec_name = os.getenv('SKYTEMPLE_ARMIPS_EXEC', f'{prefix}armips')" "exec_name = \"${armips}/bin/armips\""
  '';

  buildInputs = [ armips ];

  propagatedBuildInputs = [ appdirs explorerscript ndspy pillow setuptools skytemple-rust tilequant ];

  doCheck = false; # requires Pokémon Mystery Dungeon ROM
  pythonImportsCheck = [ "skytemple_files" ];

  meta = with lib; {
    homepage = "https://github.com/SkyTemple/skytemple-files";
    description = "Python library to edit the ROM of Pokémon Mystery Dungeon Explorers of Sky";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ xfix marius851000 ];
  };
}
