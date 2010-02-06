{ nixpkgs ? ../../nixpkgs
, services ? ../../services
, system ? builtins.currentSystem
}:

let

  testLib = 
    (import ../lib/build-vms.nix { inherit nixpkgs services system; }) //
    (import ../lib/testing.nix { inherit nixpkgs services system; });

in with testLib; let 

  call = f: f { inherit pkgs nixpkgs system testLib; };
    
  apply = testFun: complete (call testFun);

  complete = t: t // rec {
    nodes =
      if t ? nodes then t.nodes else
      if t ? machine then { machine = t.machine; }
      else { };
    vms = buildVirtualNetwork { inherit nodes; };
    test = runTests vms t.testScript;
    report = makeReport test;
  };

in

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
