{ buildDartApplication, fetchFromGitHub, lib }:

buildDartApplication rec {
  pname = "domine";
  version = "nightly-2023-08-10";

  src = fetchFromGitHub {
    owner = "breitburg";
    repo = pname;
    rev = "d99d02b014d009b0201380a21ddaa57696dc77af";
    sha256 = "038yfa22q7lzz85czmny3c1lkv8mjv4pq62cbmh054fqvgf3k3s4";
  };

  pubspecLockFile = ./pubspec.lock;

  vendorHash = "16z3paq1nxlnzs20qlljnwa2ff6xfhdqzcq8d8izkl7w1j4hyxgn";
}
