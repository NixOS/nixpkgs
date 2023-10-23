{ lib
, stdenv
, version
, src
, sourceRoot
, substituteAll
, defaultShellPath
, bazelRC
, enableNixHacks
, coreutils
, CoreFoundation
, CoreServices
, Foundation
, IOKit
, libcxx
, cctools
, sigtool
, bash
, python3
, buildJdk
, unzip
, zip
, ...
}:

stdenv.mkDerivation {
  name = "bazel-patched-sources";
  inherit version;
  inherit src;

  dontBuild = true;

  nativeBuildInputs = [ zip unzip ];

  installPhase = ''
    mkdir $out
    cp -r . $out
  '';

}
