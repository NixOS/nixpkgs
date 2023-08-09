{ lib, buildManPages }:

buildManPages {
  pname = "execline-man-pages";
  version = "2.9.3.0.5";
  sha256 = "0fcjrj4xp7y7n1c55k45rxr5m7zpv6cbhrkxlxymd4j603i9jh6d";
  description = "Port of the documentation for the execline suite to mdoc";
  maintainers = [ lib.maintainers.sternenseemann ];
}
