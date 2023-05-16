<<<<<<< HEAD
{ lib, buildGoModule, keybase }:
=======
{ lib, buildGoModule, fetchFromGitHub, keybase }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

buildGoModule {
  pname = "kbfs";

<<<<<<< HEAD
  inherit (keybase) src version vendorHash;
=======
  inherit (keybase) src version vendorSha256;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  modRoot = "go";
  subPackages = [ "kbfs/kbfsfuse" "kbfs/redirector" "kbfs/kbfsgit/git-remote-keybase" ];

  tags = [ "production" ];
  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://keybase.io/docs/kbfs";
    description = "The Keybase filesystem";
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ avaq rvolosatovs bennofs np shofius ];
    license = licenses.bsd3;
  };
}
