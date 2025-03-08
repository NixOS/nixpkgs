pkgs:
let
  inherit (pkgs) callPackage;
in
{
  firebird_2_5 = callPackage ./2_5.nix {
    autoreconfHook = pkgs.autoreconfHook271;
    icu = pkgs.icu73;
  };
  firebird_3 = callPackage ./3.nix {
    # not working with autoreconfHook
    autoreconfHook = pkgs.autoreconfHook271;
    icu = pkgs.icu73;
  };
  firebird_4 = callPackage ./4.nix {
    autoreconfHook = pkgs.autoreconfHook271;
    icu = pkgs.icu73;
  };
}
