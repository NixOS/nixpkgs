{ lib, ruby, bundlerApp, bundlerUpdateScript }:

bundlerApp {
  pname = "oxidized";
  gemdir = ./.;

  inherit ruby;

<<<<<<< HEAD
  exes = [ "oxidized" "oxs" ];
=======
  exes = [ "oxidized" "oxidized-web" "oxidized-script" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  passthru.updateScript = bundlerUpdateScript "oxidized";

  meta = with lib; {
    description = "A network device configuration backup tool. It's a RANCID replacement!";
    homepage    = "https://github.com/ytti/oxidized";
    license     = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ nicknovitski netali ];
=======
    maintainers = with maintainers; [ willibutz nicknovitski ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms   = platforms.linux;
  };
}
