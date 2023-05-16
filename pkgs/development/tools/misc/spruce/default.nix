{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "spruce";
<<<<<<< HEAD
  version = "1.30.2";
=======
  version = "unstable-2022-02-10";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "geofffranks";
    repo = pname;
<<<<<<< HEAD
    rev = "v${version}";
    hash = "sha256-flY81xiUfOyfdavhF0AyIwrB2G8N6BWltdGMT2uf9Co=";
  };

  vendorHash = null;
=======
    rev = "473931f33fceae90b3f5cfb7616c296343a9559b";
    sha256 = "sha256-TFyWkoAKmj3KH2pqhVKMtP6QKTtu0s7H5gNP+fotUzg=";
  };

  deleteVendor = true;
  vendorSha256 = "sha256-VeC5c/BgcxK3Qawb2QOhqtfTIgbQbrQj546zX6yPD+s=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A BOSH template merge tool";
    homepage = "https://github.com/geofffranks/spruce";
    license = licenses.mit;
    maintainers = with maintainers; [ risson ];
  };
}
