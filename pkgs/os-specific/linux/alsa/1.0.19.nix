{fetchurl, stdenv, ncurses, gettext}:

let version = "1.0.19"; in

rec {
  alsaLib = import ./common.nix {
    pkgName = "lib";
    sha256 = "11i898dc6qbachn046gl6dg6g7bl2k8crddl97f3z5i57bcjdvij";
    inherit fetchurl stdenv version;
  };

  alsaUtils = import ./common.nix {
    pkgName = "utils";
    sha256 = "1bcchd5nwgb2hy0z9c6jxbqlzirkh6wvxv6nldjcwmvqmvsj8j8z";
    buildInputs = [alsaLib ncurses gettext];
    inherit fetchurl stdenv version;
  };
}
