{ lib
, pkgs
, makeScopeWithSplicing'
, generateSplicesForMkScope
, gnat
}:
let
  gnat_version = lib.versions.major gnat.version;
in
makeScopeWithSplicing' {
  otherSplices = generateSplicesForMkScope ("gnat" + gnat_version + "Packages");
  f = (self: {
    inherit gnat;

    gpr2 = self.callPackage ../development/ada-modules/gpr2 { };

    gprbuild-boot = self.callPackage ../development/ada-modules/gprbuild/boot.nix { };
    gprbuild      = self.callPackage ../development/ada-modules/gprbuild { };

    xmlada = self.callPackage ../development/ada-modules/xmlada { };

    gnatprove = self.callPackage ../development/ada-modules/gnatprove {
      ocamlPackages = pkgs.ocaml-ng.ocamlPackages_4_14;
    };

    gnatcoll-core     = self.callPackage ../development/ada-modules/gnatcoll/core.nix { };

    # gnatcoll-bindings repository
    gnatcoll-cpp      = self.callPackage ../development/ada-modules/gnatcoll/bindings.nix { component = "cpp"; };
    gnatcoll-gmp      = self.callPackage ../development/ada-modules/gnatcoll/bindings.nix { component = "gmp"; };
    gnatcoll-iconv    = self.callPackage ../development/ada-modules/gnatcoll/bindings.nix { component = "iconv"; };
    gnatcoll-lzma     = self.callPackage ../development/ada-modules/gnatcoll/bindings.nix { component = "lzma"; };
    gnatcoll-omp      = self.callPackage ../development/ada-modules/gnatcoll/bindings.nix { component = "omp"; };
    gnatcoll-python3  = self.callPackage ../development/ada-modules/gnatcoll/bindings.nix { component = "python3"; python3 = pkgs.python312; };
    gnatcoll-readline = self.callPackage ../development/ada-modules/gnatcoll/bindings.nix { component = "readline"; };
    gnatcoll-syslog   = self.callPackage ../development/ada-modules/gnatcoll/bindings.nix { component = "syslog"; };
    gnatcoll-zlib     = self.callPackage ../development/ada-modules/gnatcoll/bindings.nix { component = "zlib"; };

    # gnatcoll-db repository
    gnatcoll-postgres = self.callPackage ../development/ada-modules/gnatcoll/db.nix { component = "postgres"; };
    gnatcoll-sql      = self.callPackage ../development/ada-modules/gnatcoll/db.nix { component = "sql"; };
    gnatcoll-sqlite   = self.callPackage ../development/ada-modules/gnatcoll/db.nix { component = "sqlite"; };
    gnatcoll-xref     = self.callPackage ../development/ada-modules/gnatcoll/db.nix { component = "xref"; };
    gnatcoll-db2ada   = self.callPackage ../development/ada-modules/gnatcoll/db.nix { component = "gnatcoll_db2ada"; };
    gnatinspect       = self.callPackage ../development/ada-modules/gnatcoll/db.nix { component = "gnatinspect"; };
  });
}

