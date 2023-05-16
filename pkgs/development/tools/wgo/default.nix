<<<<<<< HEAD
{ lib
, buildGoModule
, fetchFromGitHub
}:

let
  pname = "wgo";
  version = "0.5.3";
in
buildGoModule {
  inherit pname version;
=======
{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "wgo";
  version = "0.5.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "bokwoon95";
    repo = "wgo";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Uny5FiMox0oIaJ+WE7p3kw4guSzktEF+WzuxjgFXh2I=";
  };

  vendorHash = "sha256-w6UJxZToHbbQmuXkyqFzyssFcE+7uVNqOuIF/XKdEsU=";
=======
    hash = "sha256-kfa3Lm2oJomhoHbtSPLylRr+BFGV/y7xqSIv3xHHg3Q=";
  };

  vendorSha256 = "sha256-jxyO3MGrC+y/jJuwur/+tLIsbxGnT57ZXYzaf1lCv7A=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [ "-s" "-w" ];

  subPackages = [ "." ];

  meta = with lib; {
    description = "Live reload for Go apps";
    homepage = "https://github.com/bokwoon95/wgo";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
  };
}
=======
    maintainers = with maintainers; [ bokwoon95 ];
  };
}

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
