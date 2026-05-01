{
  lib,
  stdenv,
  fetchFromGitHub,
  yarn-berry_4,
  nodejs,
  makeWrapper,
  python3,
  writableTmpDirAsHomeHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ansible-language-server";
  version = "1.2.4"; # Language server version from the repo at packages/ansible-language-server/package.json
  vscodeAnsibleVersion = "26.1.3"; # vscode-ansible version

  src = fetchFromGitHub {
    owner = "ansible";
    repo = "vscode-ansible";
    tag = "v${finalAttrs.vscodeAnsibleVersion}";
    hash = "sha256-DsEW3xP8Fa9nwPuyEFVqG6rvAZgr4TDB6jhyixdvqt8=";
  };

  missingHashes = ./missing-hashes.json;

  offlineCache = yarn-berry_4.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-GScYVFdG8MMtPjtXfz7e6Y+A1tFMF9T8suvU+/BhsHY=";
  };

  nativeBuildInputs = [
    nodejs
    yarn-berry_4
    yarn-berry_4.yarnBerryConfigHook
    makeWrapper
    writableTmpDirAsHomeHook
  ];

  # Prevent native module builds (e.g. keytar from the VS Code extension workspace)
  # The language server only needs TypeScript compilation, done manually in buildPhase
  env.YARN_ENABLE_SCRIPTS = "0";

  buildPhase = ''
    runHook preBuild
    cd packages/ansible-language-server
    rm -rf test
    yarn run compile
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/node_modules/ansible-language-server
    cp -r out package.json $out/lib/node_modules/ansible-language-server/

    cd ../..
    cp -rL node_modules $out/lib/node_modules/ansible-language-server/

    mkdir -p $out/lib/node_modules/ansible-language-server/bin
    cp packages/ansible-language-server/bin/ansible-language-server $out/lib/node_modules/ansible-language-server/bin/

    mkdir -p $out/bin
    makeWrapper ${nodejs}/bin/node $out/bin/ansible-language-server \
      --prefix PATH : ${python3}/bin \
      --add-flags "$out/lib/node_modules/ansible-language-server/out/server/src/server.js"
    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/ansible/vscode-ansible/releases/tag/v${finalAttrs.vscodeAnsibleVersion}";
    description = "Ansible Language Server";
    mainProgram = "ansible-language-server";
    homepage = "https://github.com/ansible/vscode-ansible";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dtvillafana
      robsliwi
    ];
  };
})
