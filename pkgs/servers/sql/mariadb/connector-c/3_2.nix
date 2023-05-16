{ callPackage, ... } @ args:

callPackage ./. (args // {
<<<<<<< HEAD
  version = "3.2.7";
  hash = "sha256-nXGWJI5ml8Ccc+Fz/psoIEX1XsnXrnQ8HrrQi56lbdo=";
=======
  version = "3.2.5";
  sha256 = "0w0fimdiiqrrm012iflz8l4rnafryq7y0qqijzxn7nwzxhm9jsr9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
})
