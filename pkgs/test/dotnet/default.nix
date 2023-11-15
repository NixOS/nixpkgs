{ callPackage }:

{
  simple-build = callPackage ./simple-build { };
  project-references = callPackage ./project-references { };
  publish-trimmed = callPackage ./publish-trimmed { };
}
