{ lib, stdenv, fetchurl, autoPatchelfHook, makeWrapper, installShellFiles }:

with lib;

let
  data = import ./data.nix {};
in stdenv.mkDerivation {
  pname = "pulumi";
  version = data.version;

  postUnpack = ''
    mv pulumi-* pulumi
  '';

  srcs = map (x: fetchurl x) data.pulumiPkgs.${stdenv.hostPlatform.system};

  installPhase = ''
    install -D -t $out/bin/ *
  '' + optionalString stdenv.isLinux ''
    wrapProgram $out/bin/pulumi --set LD_LIBRARY_PATH "${stdenv.cc.cc.lib}/lib"
  '' + ''
    installShellCompletion --cmd pulumi \
      --bash <($out/bin/pulumi completion bash) \
      --fish <($out/bin/pulumi completion fish) \
      --zsh  <($out/bin/pulumi completion zsh)
  '';

  nativeBuildInputs = [ installShellFiles ] ++ optionals stdenv.isLinux [ autoPatchelfHook makeWrapper ];

  meta = {
    homepage = "https://pulumi.io/";
    description = "Pulumi is a cloud development platform that makes creating cloud programs easy and productive";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = with licenses; [ asl20 ];
    platforms = builtins.attrNames data.pulumiPkgs;
    maintainers = with maintainers; [
      ghuntley
      peterromfeldhk
      jlesquembre
      cpcloud
    ];
  };
}
