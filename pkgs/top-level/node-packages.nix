{ pkgs, stdenv, nodejs }:

let buildNodePackage = import ../development/web/nodejs/build-node-package.nix {
  inherit stdenv nodejs;
}; in

with pkgs;

let self = {
};

in self
