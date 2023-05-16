{ lib, fetchFromGitHub, buildGoModule, fetchpatch }:

buildGoModule rec {
  version = "0.6.0";
  pname = "grobi";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "fd0";
    repo = "grobi";
<<<<<<< HEAD
    hash = "sha256-evgDY+OjfQ0ngf4j/D4yOeITHQXmBmw8KiJhLKjdVAw=";
  };

  vendorHash = "sha256-cvP8M9pW58WwHvhXTMYqivNVGzHjDYlOd8/PvnLpfMU=";
=======
    sha256 = "032lvnl2qq9258y6q1p60lfi7qir68zgq8zyh4khszd3wdih7y3s";
  };

  vendorSha256 = "1ibwx5rbxkygfx78j3g364dmbwwa5b34qmzq3sqcbrsnv8rzrwvj";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  patches = [
    # fix failing test on go 1.15
    (fetchpatch {
      url = "https://github.com/fd0/grobi/commit/176988ab087ff92d1408fbc454c77263457f3d7e.patch";
<<<<<<< HEAD
      hash = "sha256-YfjRV7kQxxGw3nQgB12tZOAJKBW21d9xx6BSou0bHkk=";
=======
      sha256 = "0j8y3gns4lm0qxqxzmdn2ll0kq34mmfhf83lvsq13iqhp5bx3y31";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    })
  ];

  meta = with lib; {
    homepage = "https://github.com/fd0/grobi";
    description = "Automatically configure monitors/outputs for Xorg via RANDR";
    license = with licenses; [ bsd2 ];
    platforms   = platforms.linux;
  };
}
