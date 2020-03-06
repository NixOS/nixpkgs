{ lib, stdenv, fetchurl, autoPatchelfHook }:

with lib;

let
  data = import ./data.nix {};
in stdenv.mkDerivation {
  pname = "pulumi";
  version = data.version;

  srcs = map (x: fetchurl x) data.pulumiPkgs.${stdenv.hostPlatform.system};

  postUnpack = ''
    mv pulumi-* pulumi
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp * $out/bin/
  '';

  nativeBuildInputs = [ autoPatchelfHook ];
  runtimeDependencies = [ stdenv.cc.cc ];

  meta = {
    homepage = "https://pulumi.io/";
    description = "Pulumi is a cloud development platform that makes creating cloud programs easy and productive";
    license = with licenses; [ asl20 ];
    platforms = builtins.attrNames data.pulumiPkgs;
    maintainers = with maintainers; [
      peterromfeldhk
      jlesquembre
    ];
  };
}
