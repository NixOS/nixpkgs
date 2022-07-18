{ callPackage, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    python = python3;
  };
in
buildNodejs {
  inherit enableNpm;
  version = "18.6.0";
  sha256 = "0k05phvlpwf467sbaxcvdzr4ncclm9fpldml8fbfrjigl4rhr2sz";
  patches = [
    ./disable-darwin-v8-system-instrumentation.patch
  ];
}
