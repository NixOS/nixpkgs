{ lib
, stdenv
, fetchzip
, buildFHSEnv
}:

let
  version = "23.1.7";
  name = "cockroachdb-${version}";

  # For several reasons building cockroach from source has become
  # nearly imposible. See https://github.com/NixOS/nixpkgs/pull/152626
  # Therefore we use the pre-build release binary and wrap it with buildFHSUserEnv to
  # work on nix.
  # You can generate the hashes with
  # nix flake prefetch <url>
  src = fetchzip (lib.getAttr stdenv.system {
    x86_64-linux = {
      name = "cockroachdb-release-${version}";
      url = "https://binaries.cockroachdb.com/cockroach-v${version}.linux-amd64.tgz";
      sha256 = "sha256-FL/zDrl+QstBp54LE9/SbIfSPorneGZSef6dcOQJbSo=";
    };
  });

in
buildFHSEnv {
  inherit name;

  runScript = "${src}/cockroach";

  meta = with lib; {
    homepage = "https://www.cockroachlabs.com";
    description = "A scalable, survivable, strongly-consistent SQL database";
    license = licenses.bsl11;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ rushmorem thoughtpolice neosimsim ];
  };
}
