{ callPackage, ... } @ args:

callPackage ./. (args // {
  version = "25.3.26";
  sha256 = "0fs0c1px9lknf1a5wwb12z1hj7j7b6hsfjddggikvkdkrnr2xs1f";
})
