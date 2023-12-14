{ callPackage, ... } @ args:

callPackage ./. (args // {
  version = "3.3.5";
  hash = "sha256-ynLrJvbbK++nfkj/lm9xvNPLRLM72Lu4ELZebQEcHlw=";
})
