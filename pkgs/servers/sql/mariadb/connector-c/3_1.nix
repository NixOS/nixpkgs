{ callPackage, ... } @ args:

callPackage ./. (args // {
  version = "3.1.13";
  sha256 = "0xb8fiissblxb319y5ifqqp86zblwis789ipb753pcb4zpnsaw82";
})
