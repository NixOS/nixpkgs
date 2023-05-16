{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "galer";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "dwisiswant0";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-i3rrXpKnUV9REnn4lQWIFpWc2SzkxVomruiAmcMBQ6Q=";
  };

  vendorHash = "sha256-2nJgQfSeo9GrK6Kor29esnMEFmd5pTd8lGwzRi4zq1w=";
=======
    sha256 = "1923071rk078mqk5mig45kcrr58ni02rby3r298myld7j9gfnylb";
  };

  vendorSha256 = "0p5b6cp4ccvcjiy3g9brcwb08wxjbrpsza525fmx38wyyi0n0wns";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Tool to fetch URLs from HTML attributes";
    homepage = "https://github.com/dwisiswant0/galer";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
