{ lib
, bundlerApp
, bundlerUpdateScript
}:

<<<<<<< HEAD
bundlerApp {
=======
bundlerApp rec {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "pru";
  gemdir = ./.;
  exes = [ "pru" ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    homepage = "https://github.com/grosser/pru";
    description = "Pipeable Ruby";
    longDescription = ''
      pru allows to use Ruby scripts as filters, working as a convenient,
      higher-level replacement of typical text processing tools (like sed, awk,
      grep etc.).
    '';
<<<<<<< HEAD
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ AndersonTorres ];
  };

  passthru.updateScript = bundlerUpdateScript "pru";
=======
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
  };

  passthru.updateScript = bundlerUpdateScript pname;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
