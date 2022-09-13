{ lib
, stdenv
, fetchFromGitHub
, phpPackages
, pkgs
}:

let
  package = (import ./composition.nix {
    inherit pkgs;
    inherit (stdenv.hostPlatform) system;
    noDev = true; # Disable development dependencies
  });
in package.override rec {
  pname = "pixelfed";
  version = "UNSTABLE-01-09-2022";

  # GitHub distribution does not include vendored files
  src = fetchFromGitHub {
    owner = "pixelfed";
    repo = pname;
    # use an unstable version until a release contains composer.lock
    rev = "ee0cb393c642aa3781a7ed2eec43b3113843b566";
    hash = "sha256-cw/9oXz15tigMlOV8QW6/DIrRlXgQhpdSIexZUlxNOA=";
  };

  meta = with lib; {
    description = "A federated image sharing platform";
    license = licenses.agpl3Only;
    homepage = "https://pixelfed.org/";
    maintainers = with maintainers; [ bezmuth ];
    platforms = platforms.all;
  };
}
