{ callPackage, ... } @ args:

callPackage ./. (args // {
  version = "3.2.7";
  hash = "sha256-F7s9fcbJiz6lsWrvlTpY+ZET8MPwlyWPKJZOvHEwBvo=";
})
