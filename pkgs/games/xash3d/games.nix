/* Each game needs its own version of the hlsdk.
   There is a branch at upstream corresponding to each game's needed version.
   For example for gearbox there is a opfor branch at
   https://github.com/FWGS/hlsdk-portable/tree/opfor */
{ lib, stdenv, fetchFromGitHub, callPackage }:

let
  games = {
    valve = {
      fullname = "Half-Life";
      version = "unstable-2023-07-17";
      rev = "8180cf60c270b933096506f61d07ed03ba3619af";
      hash = "sha256-HPPsP2Y8LQFbMDek//xrsKaDULhDsdeTQyZYDnmOzt0=";
      dllname = "hl";
    };

    bshift = {
      fullname = "Half-Life: Blue Shift";
      version = "unstable-2023-07-17";
      rev = "818632f2baf2cf610c7fadbc2ec1ad906f1a8f29";
      hash = "sha256-UymPWgiQKxZnPuoTCPdAaCMLmlZEjlr1aA5x+oYW6LI=";
    };

    gearbox = {
      fullname = "Half-Life: Opposing Force";
      version = "unstable-2023-07-17";
      rev = "ee125707e2185d8bf3f35f8da67fafa893769c4f";
      hash = "sha256-w4Gg5kTB6yUj+BZxDMLMEksMBAdjQlywHuFAROdTZBo=";
      dllname = "opfor";
    };
  };

  toDrv = name: attrs:
    let
      hlsdk = callPackage ./hlsdk.nix {
        inherit name;
        inherit (attrs) version rev hash;
      };
      game = callPackage ./wrapper.nix ({
        inherit name hlsdk;
        inherit (attrs) fullname;
      } // lib.optionalAttrs (attrs ? dllname) { inherit (attrs) dllname; });
  in lib.nameValuePair "xash3d-${name}" game;

in lib.mapAttrs' toDrv games
