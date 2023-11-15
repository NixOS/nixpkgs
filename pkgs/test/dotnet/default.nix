{ callPackage }:

{
  project-references = callPackage ./project-references { };
  publish-trimmed = callPackage ./publish-trimmed { };
}
