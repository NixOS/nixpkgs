{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pcstat";
<<<<<<< HEAD
  version = "0.0.2";
=======
  version = "0.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "tobert";
    repo = "pcstat";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-e8fQZEfsS5dATPgshJktfKVTdZ9CvN1CttYipMjpGNM=";
  };

  vendorHash = "sha256-fdfiHTE8lySfyiKKiYJsQNCY6MBfjaVYSIZXtofIz3E=";
=======
    sha256 = "sha256-rN6oqhvrzMBhwNLm8+r4rZWZYZUhOq2h764KVhSycNo=";
  };

  vendorSha256 = "sha256-1y6rzarkFNX8G4E9FzCLfWxULbdNYK3DeelNCJ+7Y9Q=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Page Cache stat: get page cache stats for files on Linux";
    homepage = "https://github.com/tobert/pcstat";
    license = licenses.asl20;
    maintainers = with maintainers; [ aminechikhaoui ];
  };
}
