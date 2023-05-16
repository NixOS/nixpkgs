{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "pwdsafety";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ryMLiehJVZhQ3ZQf4/g7ILeJri78A6z5jfell0pD9E8=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-b+tWTQUyYDzY2O28hwy5vI6b6S889TCiVh7hQhw/KAc=";
=======
  vendorSha256 = "sha256-b+tWTQUyYDzY2O28hwy5vI6b6S889TCiVh7hQhw/KAc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Command line tool checking password safety";
    homepage = "https://github.com/edoardottt/pwdsafety";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
