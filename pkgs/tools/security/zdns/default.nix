{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "zdns";
<<<<<<< HEAD
  version = "2023-04-09-unstable";
=======
  version = "2022-03-14-unstable";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "zmap";
    repo = pname;
<<<<<<< HEAD
    rev = "ac6c7f30a7f5e11f87779f5275adeed117227cd6";
    hash = "sha256-que2uzIH8GybU6Ekumg/MjgBHSmFCF+T7PWye+25kaY=";
  };

  vendorHash = "sha256-daMPk1TKrUXXqCb4WVkrUIJsBL7uzXLJnxWNbHQ/Im4=";
=======
    rev = "d659a361f6d5165462c10e1c1243f420175e066b";
    hash = "sha256-856O6H03me3IM39/+6n56KJIetL+v4on6+lJx5D2Pcw=";
  };

  vendorSha256 = "sha256-5kZ0voyicnqK/0yrMYW+gR1vVDyptW6I1HgyG4zleX8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "CLI DNS lookup tool";
    homepage = "https://github.com/zmap/zdns";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
