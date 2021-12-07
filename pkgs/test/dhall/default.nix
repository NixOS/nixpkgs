{ lib, callPackage }:

lib.recurseIntoAttrs {
  buildDhallUrl = callPackage ./buildDhallUrl { };
  generateDhallDirectoryPackage = callPackage ./generateDhallDirectoryPackage { };
}
