{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "goconst";
<<<<<<< HEAD
  version = "1.6.0";
=======
  version = "1.5.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  excludedPackages = [ "tests" ];

  src = fetchFromGitHub {
    owner = "jgautheron";
    repo = "goconst";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-gd+0Gm1qANwgYKWAxpU7759BhyURalJCRxd/P6sczc4=";
  };

  vendorHash = null;
=======
    sha256 = "sha256-chBWxOy9V4pO3hMaeCoKwnQxIEYiSejUOD3QDBCpaoE=";
  };

  vendorSha256 = null;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Find in Go repeated strings that could be replaced by a constant";
    homepage = "https://github.com/jgautheron/goconst";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
