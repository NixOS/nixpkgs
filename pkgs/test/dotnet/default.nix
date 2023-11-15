{ callPackage }:

{
  simple-build = callPackage ./simple-build { };
  project-references = callPackage ./project-references { };
  publish-trimmed = callPackage ./publish-trimmed { };
  publish-ready-to-run = callPackage ./publish-ready-to-run { };
}
