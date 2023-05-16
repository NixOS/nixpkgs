{ rustPlatform, fetchFromGitHub, lib }:

rustPlatform.buildRustPackage rec {
  pname = "xcp";
<<<<<<< HEAD
  version = "0.12.0";
=======
  version = "0.9.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "tarka";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-QCoH8N6HDpXQXWchccGIG/pbDx9qZ8YKM6VP6lxoYzU=";
=======
    sha256 = "sha256-MvtMgdlMVMp2qWN+EbAKZwBwW0TA8aivlJY8KZm+7jM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # no such file or directory errors
  doCheck = false;

<<<<<<< HEAD
  cargoHash = "sha256-F51BHBUaQx1xg0Y2eVnXGRCMykbzk3q5IyJ528JyA5o=";
=======
  cargoHash = "sha256-vxfoJnyG0wWgkcZpQYiKkQaHl01VDuQ0kA26MXVCgY8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "An extended cp(1)";
    homepage = "https://github.com/tarka/xcp";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ lom ];
  };
}
