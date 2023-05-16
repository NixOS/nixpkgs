{ fetchFromGitHub, lib, buildGoModule }:

buildGoModule rec {
  pname = "dolt";
<<<<<<< HEAD
  version = "1.14.0";
=======
  version = "0.40.28";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "dolthub";
    repo = "dolt";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-dLIT0EPtz1a1v48axT1xRcgKGJwXFjNnzu5eUzF4QXw=";
  };

  modRoot = "./go";
  subPackages = [ "cmd/dolt" ];
  vendorHash = "sha256-s9ACHwgdElFqmgnryVsKfVFqoy153prtyJx03qNI/KU=";
  proxyVendor = true;
=======
    sha256 = "sha256-ROwOe3/D9f8+n4S35kGiSTv2sQ8nurdSL5t1zhRnTkQ=";
  };

  modRoot = "./go";
  subPackages = [ "cmd/dolt" "cmd/git-dolt" "cmd/git-dolt-smudge" ];
  vendorSha256 = "sha256-hr3PotsHk/BpOm4QLM84Jd5ZBGaj/xp/qWPfbBpKF00=";

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  doCheck = false;

  meta = with lib; {
    description = "Relational database with version control and CLI a-la Git";
    homepage = "https://github.com/dolthub/dolt";
    license = licenses.asl20;
    maintainers = with maintainers; [ danbst ];
  };
}
