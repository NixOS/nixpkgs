{ recurseIntoAttrs
, callPackage
}:

recurseIntoAttrs rec {
  optifine-latest = optifine_1_18_1;

  optifine_1_18_1 = callPackage ./generic.nix {
    version = "1.18.1_HD_U_H4";
    sha256 = "sha256-MlFoVpshotzegpmYdvaeydivdSAqcCFpHyq+3k2B3Ow=";
  };

  optifine_1_17_1 = callPackage ./generic.nix {
    version = "1.17.1_HD_U_H1";
    sha256 = "sha256-HHt747bIHYY/WNAx19mNgvnLrLCqaKIqwXmmB7A895M=";
  };

  optifine_1_16_5 = callPackage ./generic.nix {
    version = "1.16.5_HD_U_G8";
    sha256 = "sha256-PHa8kO1EvOVnzufCDrLENhkm8jqG5TZ9WW9uYk0LSU8=";
  };

  optifine_1_15_2 = callPackage ./generic.nix {
    version = "1.16.5_HD_U_G8";
    sha256 = "sha256-PHa8kO1EvOVnzufCDrLENhkm8jqG5TZ9WW9uYk0LSU8=";
  };

  optifine_1_14_4 = callPackage ./generic.nix {
    version = "1.14.4_HD_U_G5";
    sha256 = "sha256-I+65vQO6yG4AQ0ZLAfX73ImsFKAQkTyrIOnQHldTibs=";
  };

  optifine_1_13_2 = callPackage ./generic.nix {
    version = "1.13.2_HD_U_G5";
    sha256 = "sha256-sjUQot8fPdbZTiLqt+exbF5T8kI5bLQevu7atW9Xu3E=";
  };

  optifine_1_12_2 = callPackage ./generic.nix {
    version = "1.12.2_HD_U_G5";
    sha256 = "sha256-OwAGeXdx/rl/LQ0pCK58mnjO+y5zCvHC6F0IqDm6Jx4=";
  };

  optifine_1_11_2 = callPackage ./generic.nix {
    version = "1.11.2_HD_U_G5";
    sha256 = "sha256-1sLUBtM5e5LDTUFCRZf9UeH6WOA8zY6TAmB9PCS5iv4=";
  };

  optifine_1_10 = callPackage ./generic.nix {
    version = "1.10_HD_U_I5";
    sha256 = "sha256-oKOsaNFnOKfhWLDDYG/0Z4h/ZCDtyJWS9LXPaKAApc0=";
  };

  optifine_1_9_4 = callPackage ./generic.nix {
    version = "1.9.4_HD_U_I5";
    sha256 = "sha256-t+OxIf0Tl/NZxUTl+LGnWRUhEwZ+vxiZfhclxEAf6yI=";
  };

  optifine_1_8_9 = callPackage ./generic.nix {
    version = "1.8.9_HD_U_M5";
    sha256 = "sha256-Jzl2CnD8pq5cfcgXvMYoPxj1Xjj6I3eNp/OHprckssQ=";
  };

  optifine_1_7_10 = callPackage ./generic.nix {
    version = "1.7.10_HD_U_E7";
    sha256 = "sha256-i82dg94AGgWR9JgQXzafBwxH0skZJ3TVpbafZG5E+rQ=";
  };
}
