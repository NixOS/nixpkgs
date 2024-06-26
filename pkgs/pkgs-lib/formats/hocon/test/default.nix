{ pkgs, ... }:
{
  comprehensive = pkgs.callPackage ./comprehensive { };
  backwards-compatibility =
    let
      pkgsNoWarn = pkgs.extend (
        final: prev: {
          lib = prev.lib.extend (
            libFinal: libPrev: {
              warn = msg: v: v;
              trivial = libPrev.trivial // {
                warn = msg: v: v;
              };
            }
          );
        }
      );
    in
    pkgsNoWarn.callPackage ./backwards-compatibility { };
}
