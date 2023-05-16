{ lib, bundlerApp, bundlerUpdateScript }:

bundlerApp {
  pname = "vpsfree-client";
  gemdir = ./.;
  exes = [ "vpsfreectl" ];

  passthru.updateScript = bundlerUpdateScript "vpsfree-client";

  meta = with lib; {
    description = "Ruby API and CLI for the vpsFree.cz API";
    homepage = "https://github.com/vpsfreecz/vpsfree-client";
<<<<<<< HEAD
    maintainers = with maintainers; [ aither64 zimbatm ];
=======
    maintainers = with maintainers; [ zimbatm ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
