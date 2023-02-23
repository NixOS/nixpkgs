{ callPackage, ... }@args:
callPackage ./generic.nix ({
  version = "12.0.2";
  hash = "sha256-9RD4ETQEXnj3d5YID3f3BghwitdqfcDgNhsk8ixWTW4=";
  vendorHash = "sha256-2sOELuMyg7w/rhnWvnwDiUOsjUfb56JdAbrTGKvGnjs=";
  cargoHash = "sha256-1ScU5ywq8vz1sWHW2idBsWcB1Xs+aylukBm96dKrwL4=";
  yarnHash = "sha256-ItRi5EkYrwNB1MIf9l3yyK1BX6vNpL2+H1BlN3Evibg=";
} // builtins.removeAttrs args [ "callPackage" ])
