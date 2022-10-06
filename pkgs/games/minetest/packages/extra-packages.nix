{ lib
, buildMinetestPackage
, fetchgit
, fetchurl
, fetchzip
, fetchFromGitHub
}:
{

  luacmd = buildMinetestPackage rec {
    type = "mod";
    pname = "luacmd";
    version = "1.2";
    src = fetchFromGitHub {
      owner = "prestidigitator";
      repo = "minetest-mod-luacmd";
      rev = version;
      hash = "sha256-WV19m8p6SwTKjDC7+N+EPW7hz6xg+inxIFkJOetY9x8=";
    };
    meta = with lib; {
      description = "Provides a /lua command for executing Lua code right from the game console";
      license = licenses.wtfpl;
      maintainers = with maintainers; [ fgaz ];
    };
  };

  zombies = buildMinetestPackage {
    pname = "zombies";
    version = "unstable-2016-03-15";
    src = fetchFromGitHub {
      owner = "minetest-mods";
      repo = "zombies";
      rev = "0e633a5b1c7174e73c57cb2cdd676470eab9d627";
      hash = "sha256-hXJIYMNz1U423qvtRT43NsdsAJsdIyHkt8rAFVnbxGE=";
    };
    meta = with lib; {
      description = "Zombies based on TenPlus1's Mob API";
      license = licenses.mit;
      maintainers = with maintainers; [ hllizi ];
    };
  };

}
