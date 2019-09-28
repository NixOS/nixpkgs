{ callPackage, ... } @ args:

callPackage ./. (args // {
  version = "25.3.27";
  sha256 = "143kzj0fmak1gdww4qkqmmliw8klxm6mwk5531748swlwm6gqr5q";
})
