{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, appdirs
, dungeon-eos
, explorerscript
, ndspy
, pillow
, setuptools
, skytemple-rust
, tilequant
, pyyaml
, pmdsky-debug-py
, typing-extensions
, pythonOlder
, # optional dependancies for SpriteCollab
  aiohttp
, lru-dict
, graphql-core
, gql
, armips
<<<<<<< HEAD
  # tests
=======
# tests
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytestCheckHook
, parameterized
, xmldiff
}:

buildPythonPackage rec {
  pname = "skytemple-files";
<<<<<<< HEAD
  version = "1.5.4";
=======
  version = "1.4.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-RB+Cp4mL0y59/l7yu0z3jefADHR9/h0rbTZLm7BvJ7k=";
=======
    hash = "sha256-SLRZ9ThrH2UWqfr5BbjJKDM/SRkCfMNK70XZT4+Ks7w=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace skytemple_files/patch/arm_patcher.py \
      --replace "exec_name = os.getenv('SKYTEMPLE_ARMIPS_EXEC', f'{prefix}armips')" "exec_name = \"${armips}/bin/armips\""
  '';

  buildInputs = [ armips ];

  propagatedBuildInputs = [
    appdirs
    dungeon-eos
    explorerscript
    ndspy
    pillow
    setuptools
    skytemple-rust
    tilequant
    pyyaml
    pmdsky-debug-py
  ] ++ lib.optionals (pythonOlder "3.9") [
    typing-extensions
  ];

  passthru.optional-dependencies = {
    spritecollab = [
      aiohttp
      gql
      graphql-core
      lru-dict
    ] ++ gql.optional-dependencies.aiohttp;
  };

  checkInputs = [ pytestCheckHook parameterized xmldiff ] ++ passthru.optional-dependencies.spritecollab;
<<<<<<< HEAD
  pytestFlagsArray = [ "test/" ];
=======
  pytestFlagsArray = "test/";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  disabledTestPaths = [
    "test/skytemple_files_test/common/spritecollab/sc_online_test.py"
    "test/skytemple_files_test/compression_container/atupx/atupx_test.py" # Particularly long test
  ];

  pythonImportsCheck = [ "skytemple_files" ];

  meta = with lib; {
    homepage = "https://github.com/SkyTemple/skytemple-files";
    description = "Python library to edit the ROM of Pokémon Mystery Dungeon Explorers of Sky";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ xfix marius851000 ];
    broken = stdenv.isDarwin; # pyobjc is missing
  };
}
