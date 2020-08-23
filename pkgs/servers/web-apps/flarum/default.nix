{ pkgs }:

{
  src = pkgs.fetchFromGitHub {
    owner = "flarum";
    repo = "flarum";
    rev = "v0.1.0-beta.13";
    sha256 = "0mj6w7nibdqmi7lx2r5d9yiif6lb584l93551i115a9ly3s4yinn";
  };

  dependencies = pkgs.lib.makeOverridable (import ./dependencies) {
    inherit pkgs;
    noDev = true;
  };
}
