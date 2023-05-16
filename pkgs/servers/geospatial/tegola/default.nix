{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tegola";
<<<<<<< HEAD
  version = "0.18.0";
=======
  version = "0.16.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "go-spatial";
    repo = "tegola";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-lrFRPD16AFavc+ghpKoxwQJsfJLe5jxTQVK/0a6SIIs=";
  };

  vendorHash = null;
=======
    sha256 = "sha256-W1UTh8OZpWaCLwMPQopGjSqXNgO9FoIEIJIG9yOwTtY=";
  };

  vendorSha256 = null;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "cmd/tegola" ];

  ldflags = [ "-s" "-w" "-X github.com/go-spatial/tegola/internal/build.Version=${version}" ];

  meta = with lib; {
    homepage = "https://www.tegola.io/";
    description = "Mapbox Vector Tile server";
    maintainers = with maintainers; [ ingenieroariel ];
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
  };
}
