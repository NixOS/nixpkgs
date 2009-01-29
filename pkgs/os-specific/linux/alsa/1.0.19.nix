args: with args;

rec {
  alsaLib = (import ./common.nix) {
    aName = "lib";
    sha256 = "11i898dc6qbachn046gl6dg6g7bl2k8crddl97f3z5i57bcjdvij";
  } args;

  alsaUtils = (import ./common.nix) {
    aName = "utils";
    sha256 = "1bcchd5nwgb2hy0z9c6jxbqlzirkh6wvxv6nldjcwmvqmvsj8j8z";
    buildInputs = [alsaLib ncurses gettext];
  } args;
}
