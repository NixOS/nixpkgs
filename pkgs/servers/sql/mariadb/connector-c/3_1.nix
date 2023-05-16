{ callPackage, ... } @ args:

callPackage ./. (args // {
<<<<<<< HEAD
  version = "3.1.21";
  hash = "sha256-PovyQvomT8+vGWS39/QjLauiGkSiuqKQpTrSXdyVyow=";
=======
  version = "3.1.13";
  sha256 = "0xb8fiissblxb319y5ifqqp86zblwis789ipb753pcb4zpnsaw82";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
})
