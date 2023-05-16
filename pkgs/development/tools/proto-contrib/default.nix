{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "proto-contrib";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "emicklei";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ksxic7cypv9gg8q5lkl5bla1n9i65z7b03cx9lwq6252glmf2jk";
  };

<<<<<<< HEAD
  vendorHash = "sha256-XAFB+DDWN7CLfNxIBqYJy88gUNrUJYExzy2/BFnBe8c=";
=======
  vendorSha256 = "sha256-XAFB+DDWN7CLfNxIBqYJy88gUNrUJYExzy2/BFnBe8c=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  meta = with lib; {
    description = "Contributed tools and other packages on top of the Go proto package";
    homepage = "https://github.com/emicklei/proto-contrib";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
  };
}
