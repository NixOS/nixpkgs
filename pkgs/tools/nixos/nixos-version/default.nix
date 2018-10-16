{ substituteAll
, lib
, version ? lib.trivial.version
, codeName ? "unknown"
, revision ? lib.trivial.revisionWithDefault "master"
}:
substituteAll {
  name = "nixos-version";
  dir = "bin";
  isExecutable = true;
  src = ./nixos-version.sh;
  inherit version codeName revision;
}
