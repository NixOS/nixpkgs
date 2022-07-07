# pkgs-lib is for functions and values that can't be in lib because
# they depend on some packages. This notably is *not* for supporting package
# building, instead pkgs/build-support is the place for that.
{ lib, pkgs }: {
  # setting format types and generators. These do not fit in lib/types.nix,
  # because they depend on pkgs for rendering some formats
  formats = import ./formats.nix {
    inherit lib pkgs;
  };

  /*
    Return attribute set of packages from overlay

    Type: callOverlay :: (pkgs -> pkgs -> attrs) -> attrs

    Example:
      evalOverlay (final: prev: { a = 42; })
      => { a = 42 }
  */
  callOverlay = overlay:
    let
      result = overlay (pkgs.extend overlay) pkgs;
    in
    result;

  /*
    Return attribute set of packages from overlays

    Type: callOverlays :: [pkgs -> pkgs -> attrs] -> attrs

    Example:
      evalOverlays [(final: prev: { a = 42; }) (final: prev: { b = 123; })]
      => { a = 42; b = 123; }
  */
  callOverlays = overlays:
      pkgs.callOverlay (lib.composeManyExtensions overlays);
}

