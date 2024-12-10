{
  lib,
  stdenvNoCC,
  callPackages,
  fetchurl,
  installShellFiles,
  nodejs,
  testers,
  withNode ? true,

  version,
  hash,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pnpm";
  inherit version;

  src = fetchurl {
    url = "https://registry.npmjs.org/pnpm/-/pnpm-${finalAttrs.version}.tgz";
    inherit hash;
  };
  # Remove binary files from src, we don't need them, and this way we make sure
  # our distribution is free of binaryNativeCode
  preConfigure = ''
    rm -r dist/reflink.*node dist/vendor
  '';

  buildInputs = lib.optionals withNode [ nodejs ];

  nativeBuildInputs = [
    installShellFiles
    nodejs
  ];

  installPhase = ''
    runHook preInstall

    install -d $out/{bin,libexec}
    cp -R . $out/libexec/pnpm
    ln -s $out/libexec/pnpm/bin/pnpm.cjs $out/bin/pnpm
    ln -s $out/libexec/pnpm/bin/pnpx.cjs $out/bin/pnpx

    runHook postInstall
  '';

  postInstall =
    if lib.toInt (lib.versions.major version) < 9 then
      ''
        export HOME="$PWD"
        node $out/bin/pnpm install-completion bash
        node $out/bin/pnpm install-completion fish
        node $out/bin/pnpm install-completion zsh
        sed -i '1 i#compdef pnpm' .config/tabtab/zsh/pnpm.zsh
        installShellCompletion \
          .config/tabtab/bash/pnpm.bash \
          .config/tabtab/fish/pnpm.fish \
          .config/tabtab/zsh/pnpm.zsh
      ''
    else
      ''
        node $out/bin/pnpm completion bash >pnpm.bash
        node $out/bin/pnpm completion fish >pnpm.fish
        node $out/bin/pnpm completion zsh >pnpm.zsh
        sed -i '1 i#compdef pnpm' pnpm.zsh
        installShellCompletion pnpm.{bash,fish,zsh}
      '';

  passthru =
    let
      fetchDepsAttrs = callPackages ./fetch-deps { pnpm = finalAttrs.finalPackage; };
    in
    {
      inherit (fetchDepsAttrs) fetchDeps configHook;

      tests.version = lib.optionalAttrs withNode (
        testers.testVersion { package = finalAttrs.finalPackage; }
      );
    };

  meta = with lib; {
    description = "Fast, disk space efficient package manager for JavaScript";
    homepage = "https://pnpm.io/";
    changelog = "https://github.com/pnpm/pnpm/releases/tag/v${finalAttrs.version}";
    license = licenses.mit;
    maintainers = with maintainers; [ Scrumplex ];
    platforms = platforms.all;
    mainProgram = "pnpm";
  };
})
