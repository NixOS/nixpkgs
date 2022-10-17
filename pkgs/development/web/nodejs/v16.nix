{ callPackage, openssl, python3, fetchpatch, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "16.17.1";
    sha256 = "sha256-ZyH+tBUtVtLGs1jOOXq9Wn8drwnuLiXFAhubTT+GozA=";
    patches = [
      ./disable-darwin-v8-system-instrumentation.patch
      # Fix npm silently fail without a HOME directory https://github.com/npm/cli/issues/4996
      (fetchpatch {
        url = "https://github.com/npm/cli/commit/9905d0e24c162c3f6cc006fa86b4c9d0205a4c6f.patch";
        sha256 = "sha256-RlabXWtjzTZ5OgrGf4pFkolonvTDIPlzPY1QcYDd28E=";
        includes = [ "deps/npm/lib/npm.js" "deps/npm/lib/utils/log-file.js" ];
        stripLen = 1;
        extraPrefix = "deps/npm/";
      })
    ];
  }
