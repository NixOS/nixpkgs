{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "3.0.24";
  sha256 = "1yxw4jg9n49dbi1mjdfpxczsznl9m6sxlzkmzjancmjzvj5s6bvz";
  generation = "3_0";
})
