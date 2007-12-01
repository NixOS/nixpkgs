args:
(import ./2.6.21.nix)
( args //
  {
      extraPatches = (if (args ? extraPatches) args.extraPatches else []) ++ 
      [
      {
        name = "Con Kolivas Patch";
        patch = ./patch-2.6.21-ck1;
      }
      ];
  }
)
