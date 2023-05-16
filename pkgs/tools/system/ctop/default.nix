{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ctop";
  version = "0.7.7";

  src = fetchFromGitHub {
    owner = "bcicen";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-tojSzgpoGQg6MwV/MVpQpCA5w6bZO+9IOvfkw0Ydr6c=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-UAja7XuoLqJFNcK1PgHGcuf/HbvSrWyRvW2D3T7Hg0g=";
=======
  vendorSha256 = "sha256-UAja7XuoLqJFNcK1PgHGcuf/HbvSrWyRvW2D3T7Hg0g=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [ "-s" "-w" "-X main.version=${version}" "-X main.build=v${version}" ];

  meta = with lib; {
    description = "Top-like interface for container metrics";
    homepage = "https://ctop.sh/";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ apeyroux marsam ];
=======
    maintainers = with maintainers; [ apeyroux marsam SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
