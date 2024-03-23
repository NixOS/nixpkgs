{ lib
, fetchFromGitHub
, installShellFiles
, makeWrapper
, buildGoModule
, fetchYarnDeps
, fixup_yarn_lock
, pkg-config
, nodejs
, yarn
, nodePackages
, python3
, terraform
}:

buildGoModule rec {
  pname = "coder";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-FHBaefwSGZXwn1jdU7zK8WhwjarknvyeUJTlhmk/hPM=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/site/yarn.lock";
    hash = "sha256-nRmEXR9fjDxvpbnT+qpGeM0Cc/qW/kN53sKOXwZiBXY=";
  };

  vendorHash = "sha256-+AvmJkZCFovE2+5Lg98tUvA7f2kBHUMzhl5IyrEGuy8=";

  tags = [ "embed" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/coder/coder/buildinfo.tag=${version}"
  ];

  subPackages = [ "cmd/..." ];

  preBuild = ''
    export HOME=$TEMPDIR

    pushd site
    yarn config --offline set yarn-offline-mirror ${offlineCache}
    fixup_yarn_lock yarn.lock

    # node-gyp tries to download always the headers and fails: https://github.com/NixOS/nixpkgs/issues/195404
    # playwright tries to download Chrome and fails
    yarn remove --offline jest-canvas-mock canvas @playwright/test playwright

    export PATH=$PATH:$(pwd)/node_modules/.bin
    NODE_ENV=production node node_modules/.bin/vite build

    popd
  '';

  nativeBuildInputs = [
    fixup_yarn_lock
    installShellFiles
    makeWrapper
    nodePackages.node-pre-gyp
    nodejs
    pkg-config
    python3
    yarn
  ];

  postInstall = ''
    installShellCompletion --cmd coder \
      --bash <($out/bin/coder completion bash) \
      --fish <($out/bin/coder completion fish) \
      --zsh <($out/bin/coder completion zsh)

    wrapProgram $out/bin/coder --prefix PATH : ${lib.makeBinPath [ terraform ]}
  '';

  # integration tests require network access
  doCheck = false;

  meta = {
    description = "Provision software development environments via Terraform on Linux, macOS, Windows, X86, ARM, and of course, Kubernetes";
    homepage = "https://coder.com";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.ghuntley lib.maintainers.urandom ];
  };
}
