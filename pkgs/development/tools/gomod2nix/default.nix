{ stdenv
, callPackage
, go
, lib
, makeWrapper
, installShellFiles
, fetchFromGitHub
, buildGoApplication
, mkGoEnv
, writeShellScript
}:

buildGoApplication {
  pwd = ./.;

  allowGoReference = true;

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  passthru = {
    inherit buildGoApplication mkGoEnv;
    updateScript = writeShellScript "gomod2nix-update" ''
      exec ${./update.sh} ${toString ../../../../.}
    '';
  };

  postInstall = lib.optionalString (stdenv.buildPlatform == stdenv.targetPlatform) ''
    installShellCompletion --cmd gomod2nix \
      --bash <($out/bin/gomod2nix completion bash) \
      --fish <($out/bin/gomod2nix completion fish) \
      --zsh <($out/bin/gomod2nix completion zsh)
  '' + ''
    wrapProgram $out/bin/gomod2nix --prefix PATH : ${lib.makeBinPath [ go ]}
  '';

  meta = {
    description = "Convert applications using Go modules -> Nix";
    homepage = "https://github.com/nix-community/gomod2nix";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.adisbladis ];
  };
}
