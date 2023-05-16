{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gotest";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "rakyll";
    repo = pname;
    rev = "v${version}";
    sha256 = "1v11ccrjghq7nsz0f91r17di14yixsw28vs0m3dwzwqkh1a20img";
  };

<<<<<<< HEAD
  vendorHash = "sha256-pVq6H1HoKqCMRfJg7FftRf3vh+BWZQe6cQAX+TBzKqw=";
=======
  vendorSha256 = "sha256-pVq6H1HoKqCMRfJg7FftRf3vh+BWZQe6cQAX+TBzKqw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "." ];

  meta = with lib; {
    description = "go test with colors";
    homepage = "https://github.com/rakyll/gotest";
    license = licenses.bsd3;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
