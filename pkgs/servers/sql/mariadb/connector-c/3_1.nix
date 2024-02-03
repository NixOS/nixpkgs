{ callPackage, ... } @ args:

callPackage ./. (args // {
  version = "3.1.21";
  hash = "sha256-PovyQvomT8+vGWS39/QjLauiGkSiuqKQpTrSXdyVyow=";
})
