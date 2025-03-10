{
  lib,
  src,
  officialRelease,
}:

scope:

let
  inherit (scope) callPackage;

  baseVersion = lib.fileContents ../.version;

  versionSuffix = lib.optionalString (!officialRelease) "pre";

  fineVersionSuffix =
    lib.optionalString (!officialRelease)
      "pre${
        builtins.substring 0 8 (src.lastModifiedDate or src.lastModified or "19700101")
      }_${src.shortRev or "dirty"}";

  fineVersion = baseVersion + fineVersionSuffix;
in

# This becomes the pkgs.nixComponents attribute set
{
  version = baseVersion + versionSuffix;
  inherit versionSuffix;

  nix-util = callPackage ../src/libutil/package.nix { };
  nix-util-c = callPackage ../src/libutil-c/package.nix { };
  nix-util-test-support = callPackage ../src/libutil-test-support/package.nix { };
  nix-util-tests = callPackage ../src/libutil-tests/package.nix { };

  nix-store = callPackage ../src/libstore/package.nix { };
  nix-store-c = callPackage ../src/libstore-c/package.nix { };
  nix-store-test-support = callPackage ../src/libstore-test-support/package.nix { };
  nix-store-tests = callPackage ../src/libstore-tests/package.nix { };

  nix-fetchers = callPackage ../src/libfetchers/package.nix { };
  nix-fetchers-tests = callPackage ../src/libfetchers-tests/package.nix { };

  nix-expr = callPackage ../src/libexpr/package.nix { };
  nix-expr-c = callPackage ../src/libexpr-c/package.nix { };
  nix-expr-test-support = callPackage ../src/libexpr-test-support/package.nix { };
  nix-expr-tests = callPackage ../src/libexpr-tests/package.nix { };

  nix-flake = callPackage ../src/libflake/package.nix { };
  nix-flake-c = callPackage ../src/libflake-c/package.nix { };
  nix-flake-tests = callPackage ../src/libflake-tests/package.nix { };

  nix-main = callPackage ../src/libmain/package.nix { };
  nix-main-c = callPackage ../src/libmain-c/package.nix { };

  nix-cmd = callPackage ../src/libcmd/package.nix { };

  nix-cli = callPackage ../src/nix/package.nix { version = fineVersion; };

  nix-functional-tests = callPackage ../tests/functional/package.nix { version = fineVersion; };

  nix-manual = callPackage ../doc/manual/package.nix { version = fineVersion; };
  nix-internal-api-docs = callPackage ../src/internal-api-docs/package.nix { version = fineVersion; };
  nix-external-api-docs = callPackage ../src/external-api-docs/package.nix { version = fineVersion; };

  nix-perl-bindings = callPackage ../src/perl/package.nix { };

  nix-everything = callPackage ../packaging/everything.nix { };
}
