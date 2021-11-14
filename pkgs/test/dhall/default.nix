{ lib, callPackage }:

lib.recurseIntoAttrs {
  buildDhallUrl = callPackage ./buildDhallUrl { };
}
