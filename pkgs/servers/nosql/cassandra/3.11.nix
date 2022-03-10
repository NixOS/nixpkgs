{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "3.11.12";
  sha256 = "16j58l7r47qrfh8q7fm92y935ykgvnbj3qn984c42qda15x92hkw";
  generation = "3_11";
})
