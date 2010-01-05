{ nixpkgs ? ../../nixpkgs
, services ? ../../services
, system ? builtins.currentSystem
}:

let

  testLib = 
    (import ../lib/build-vms.nix { inherit nixpkgs services system; }) //
    (import ../lib/testing.nix { inherit nixpkgs services system; });

  apply = testFun:
    with testLib;
    let
      t = testFun { inherit pkgs testLib; };
    in t // rec {
      nodes = if t ? nodes then t.nodes else { machine = t.machine; };
      vms = buildVirtualNetwork { inherit nodes; };
      test = runTests vms t.testScript;
      report = makeReport test;
    };

in

{
  kde4 = apply (import ./kde4.nix);
  quake3 = apply (import ./quake3.nix);
  subversion = apply (import ./subversion.nix);
}
