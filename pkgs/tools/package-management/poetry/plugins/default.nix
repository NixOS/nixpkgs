{ python, poetry }:

let
  callPackage = python.pkgs.newScope self;

  self = {
    inherit poetry;
    poetry-plugin-up = callPackage ./poetry-plugin-up { };
  };
in self
