{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  installShellFiles,
}:

let
  data = import ./data.nix { };
in
stdenv.mkDerivation {
  pname = "pulumi";
  inherit (data) version;

  postUnpack = ''
    mv pulumi-* pulumi
  '';

  srcs = map fetchurl data.pulumiPkgs.${stdenv.hostPlatform.system};

  installPhase = ''
    install -D -t $out/bin/ *
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/pulumi --set LD_LIBRARY_PATH "${lib.getLib stdenv.cc.cc}/lib"
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd pulumi \
      --bash <($out/bin/pulumi completion bash) \
      --fish <($out/bin/pulumi completion fish) \
      --zsh  <($out/bin/pulumi completion zsh)
  '';

  nativeBuildInputs = [
    installShellFiles
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
    makeWrapper
  ];
  buildInputs = [ stdenv.cc.cc.libgcc or null ];

  meta = with lib; {
    homepage = "https://pulumi.io/";
    description = "Pulumi is a cloud development platform that makes creating cloud programs easy and productive";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = with licenses; [ asl20 ];
    platforms = builtins.attrNames data.pulumiPkgs;
    maintainers = with maintainers; [
      ghuntley
      jlesquembre
      cpcloud
      wrbbz
    ];
    hydraPlatforms = [ ]; # Hydra fails with "Output limit exceeded"
  };
}
