{ callPackage, lib }:

let cargo = callPackage ./Cargo.nix {};
in (cargo.nixdoc {}).overrideAttrs (_: rec {
   name    = "nixdoc-${version}";
   version = "1.0.1";

   meta = with lib; {
     description = "Generate documentation for Nix functions";
     homepage    = https://github.com/tazjin/nixdoc;
     license     = [ licenses.gpl3 ];
     maintainers = [ maintainers.tazjin ];
     platforms   = platforms.unix;
   };
})
