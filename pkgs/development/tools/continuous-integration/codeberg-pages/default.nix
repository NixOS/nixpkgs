{ lib, fetchFromGitea, buildGoModule }:

buildGoModule rec {
  pname = "codeberg-pages";
  version = "4.6.2";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "Codeberg";
    repo = "pages-server";
    rev = "ce241fa40adee2b12f8e225db98e09a45bc2acbb";
    sha256 = "sha256-mL2Xs7eyldoZK4zrX6WFlFtwdLN0iVyl1Qh8X6b2u9c=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-R/LuZkA2xHmu7SO3BVyK1C6n9U+pYn50kNkyLltn2ng=";
=======
  vendorSha256 = "sha256-R/LuZkA2xHmu7SO3BVyK1C6n9U+pYn50kNkyLltn2ng=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  patches = [ ./disable_httptest.patch ];

  ldflags = [ "-s" "-w" ];

  tags = [ "sqlite" "sqlite_unlock_notify" "netgo" ];

  meta = with lib; {
    mainProgram = "codeberg-pages";
    maintainers = with maintainers; [ laurent-f1z1 ];
    license = licenses.eupl12;
    homepage = "https://codeberg.org/Codeberg/pages-server";
    description = "Static websites hosting from Gitea repositories";
  };
}
