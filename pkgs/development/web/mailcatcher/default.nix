<<<<<<< HEAD
{ pkgs, lib, bundlerApp, bundlerUpdateScript }:
=======
{ lib, bundlerApp, bundlerUpdateScript }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

bundlerApp {
  pname = "mailcatcher";
  gemdir = ./.;
  exes = [ "mailcatcher" "catchmail" ];
<<<<<<< HEAD
  ruby = pkgs.ruby_3_0;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  passthru.updateScript = bundlerUpdateScript "mailcatcher";

  meta = with lib; {
    description = "SMTP server and web interface to locally test outbound emails";
    homepage    = "https://mailcatcher.me/";
    license     = licenses.mit;
    maintainers = with maintainers; [ zarelit nicknovitski ];
    platforms   = platforms.unix;
  };
}
