{ lib
, buildGoModule
, curl
, fetchFromGitHub
, pkg-config
}:

buildGoModule rec {
  pname = "cameradar";
  version = "5.0.2";

  src = fetchFromGitHub {
    owner = "Ullaakut";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-GOqmz/aiOLGMfs9rQBIEQSgBycPzhu8BohcAc2U+gBw=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-AIi57DWMvAKl0PhuwHO/0cHoDKk5e0bJsqHYBka4NiU=";
=======
  vendorSha256 = "sha256-AIi57DWMvAKl0PhuwHO/0cHoDKk5e0bJsqHYBka4NiU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    curl
  ];

  subPackages = [
    "cmd/cameradar"
  ];
  # At least one test is outdated
  #doCheck = false;

  meta = with lib; {
    description = "RTSP stream access tool";
    homepage = "https://github.com/Ullaakut/cameradar";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
<<<<<<< HEAD
    # Upstream issue, doesn't build with latest curl, see
    # https://github.com/Ullaakut/cameradar/issues/320
    # https://github.com/andelf/go-curl/issues/84
    broken = true;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
