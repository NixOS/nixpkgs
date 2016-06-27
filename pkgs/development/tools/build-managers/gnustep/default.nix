{ clangStdenv, newScope }:

let
  callPackage = newScope self;

  self = rec {
    stdenv = clangStdenv;

    make = callPackage ./make {};

    xcode = callPackage ./xcode {};

    base = callPackage ./base {
      inherit libobjc make;
    };

    libobjc = callPackage ./libobjc2 {};
  };

in self
