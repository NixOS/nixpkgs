let {
  system = "i686-linux";
  pkgs   = (import ../pkgs/system/all-packages.nix) {system = system;};
  stdenv = pkgs.stdenv_;

  strategoxtdist = (import ./strategoxt-dist.nix) {
    stdenv    = stdenv;
    fetchsvn  = pkgs.fetchsvn;
    autotools = pkgs.autotools;
    which     = pkgs.which;
    aterm     = pkgs.aterm;
    sdf       = pkgs.sdf2;
  };

  tigerdist = (import ./tiger-dist.nix) {
    stdenv     = stdenv;
    fetchsvn   = pkgs.fetchsvn;
    autotools  = pkgs.autotools;
    which      = pkgs.which;
    aterm      = pkgs.aterm;
    sdf        = pkgs.sdf2;
    strategoxt = strategoxtdist;
  };

  body = [strategoxtdist tigerdist];
}
