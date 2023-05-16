{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dismember";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "liamg";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-myoBXoi7VqHOLmu/XrvnlfBDlEnXm+0fp8WQec+3EJY=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-xxZQz94sr7aSNhmvFWdRtVnS0yk2KQIkAHjwZeJPBwY=";
=======
  vendorSha256 = "sha256-xxZQz94sr7aSNhmvFWdRtVnS0yk2KQIkAHjwZeJPBwY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Tool to scan memory for secrets";
    homepage = "https://github.com/liamg/dismember";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
