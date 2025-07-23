{ pkgs }:
(pkgs.callPackage ./integration-tests { }) // (pkgs.callPackage ./fetchDenoDeps-e2e-tests { })
