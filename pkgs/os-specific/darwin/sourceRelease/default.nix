# Returns the raw source from apple-oss-distributions repo.
# This is mostly useful for copying private headers needed to build other source releases.
#
# Note: The source releases are mostly not used to build the SDK. Unless they can be used to build binaries,
# they’re not used.

let
  lockfile = builtins.fromJSON (builtins.readFile ./versions.json);
in

{ fetchFromGitHub }:

name:
let
  lockinfo = lockfile.${name};
in
fetchFromGitHub {
  owner = "apple-oss-distributions";
  repo = name;
  rev = lockinfo.rev or "${name}-${lockinfo.version}";
  inherit (lockinfo) hash;
}
// {
  inherit (lockinfo) version;
}
