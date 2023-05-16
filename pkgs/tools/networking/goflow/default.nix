{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "goflow";
  version = "3.4.4";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-nMWAvvJj1S5W4ItOT212bn9CPG5Lpdd+k8ciwGmeu0w=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-fOlfVI8v7KqNSRhAPlZBSHKfZRlCbCgjnMV/6bsqDhg=";
=======
  vendorSha256 = "sha256-fOlfVI8v7KqNSRhAPlZBSHKfZRlCbCgjnMV/6bsqDhg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A NetFlow/IPFIX/sFlow collector in Go";
    homepage = "https://github.com/cloudflare/goflow";
    license = licenses.bsd3;
    maintainers = with maintainers; [ heph2 ];
    platforms = platforms.all;
  };
}
