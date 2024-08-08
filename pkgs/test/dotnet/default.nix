{ lib, callPackage }:

{
  project-references = callPackage ./project-references { };
  use-dotnet-from-env = lib.recurseIntoAttrs (callPackage ./use-dotnet-from-env { });
  structured-attrs = lib.recurseIntoAttrs (callPackage ./structured-attrs { });
  final-attrs = lib.recurseIntoAttrs (callPackage ./final-attrs { });
}
