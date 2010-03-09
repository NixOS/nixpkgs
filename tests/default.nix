{ nixpkgs ? ../../nixpkgs
, services ? ../../services
, system ? builtins.currentSystem
}:

with import ../lib/testing.nix { inherit nixpkgs services system; };

{
  firefox = apply (import ./firefox.nix);
  installer = pkgs.lib.mapAttrs (name: complete) (call (import ./installer.nix));
  kde4 = apply (import ./kde4.nix);
  login = apply (import ./login.nix);
  portmap = apply (import ./portmap.nix);
  proxy = apply (import ./proxy.nix);
  quake3 = apply (import ./quake3.nix);
  subversion = apply (import ./subversion.nix);
  trac = apply (import ./trac.nix);
}
