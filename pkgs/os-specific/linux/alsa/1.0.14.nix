args: with args;

rec {
  alsaLib = (import ./common.nix) {
    aName = "lib";
    sha256 = "18xhm53adgss20jnva2nfl9gk46kb5an6ah820pazqn0ykd97rh1";
  } args;

  alsaUtils = (import ./common.nix) {
    aName = "utils";
    sha256 = "1jx5bwa8abx7aih4lymx4bnrmyip2yb0rp1mza97wpni1q7n6z9h";
    buildInputs = [alsaLib ncurses gettext];
  } args;
}
