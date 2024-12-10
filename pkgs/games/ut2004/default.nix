{ callPackage }:

{
  ut2004-demo = callPackage ./demo.nix { };

  ut2004 =
    gamePacks:
    callPackage ./wrapper.nix {
      inherit gamePacks;
    };
}
