{ lib
, fetchFromGitHub
, installShellFiles
, makeWrapper
, buildGoModule
, esbuild
, pkg-config
, nodejs
, yarn
, jq
, moreutils
, nodePackages
, python3
, terraform
, stdenvNoCC
}:

buildGoModule rec {
  pname = "coder";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-6XHgocfk82SU8AcCVSUFIYj1sD84V0P3koewXXrtBYw=";
  };

  pnpm-deps = stdenvNoCC.mkDerivation {
    pname = "${pname}-pnpm-deps";
    inherit src version;

    nativeBuildInputs = [
      jq
      moreutils
      nodePackages.pnpm
    ];

    installPhase = ''
      export HOME=$(mktemp -d)
      pnpm config set store-dir $out
      pushd site
      # use --ignore-script and --no-optional to avoid downloading binaries
      # use --frozen-lockfile to avoid checking git deps
      pnpm install --frozen-lockfile --no-optional --ignore-script --reporter append-only

      # Remove timestamp and sort the json files
      rm -rf $out/v3/tmp
      for f in $(find $out -name "*.json"); do
        sed -i -E -e 's/"checkedAt":[0-9]+,//g' $f
        jq --sort-keys . $f | sponge $f
      done
      popd
    '';

    dontBuild = true;
    dontFixup = true;
    outputHashMode = "recursive";
    outputHash = "sha256-103tms3p23WUCi4xaZSgeDnHrMNuMylPAzCQyw6JF1M=";
  };

  vendorHash = "sha256-ScP25MUVmsMhYRPTAsQwYkX2CA3G58qM2Ewk1zb2z4I=";

  tags = [ "embed" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/coder/coder/buildinfo.tag=${version}"
  ];

  subPackages = [ "cmd/..." ];

  preBuild = ''
    export HOME=$(mktemp -d)

    # Hack: permission error when running directly off `pnpm-deps`
    cp -r ${pnpm-deps} "$HOME/.pnmp-store"

    pushd site
    pnpm config set store-dir "$HOME/.pnmp-store"

    pnpm install --offline --frozen-lockfile --no-optional --ignore-script --reporter append-only

    pnpm typegen

    NODE_OPTIONS=--max-old-space-size=4096 pnpm build
    popd
  '';

  ESBUILD_BINARY_PATH = "${lib.getExe (esbuild.override {
    buildGoModule = args: buildGoModule (args // rec {
      version = "0.18.17";
      src = fetchFromGitHub {
        owner = "evanw";
        repo = "esbuild";
        rev = "v${version}";
        hash = "sha256-OnAOomKVUIBTEgHywDSSx+ggqUl/vn/R0JdjOb3lUho=";
      };
      vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
    });
  })}";

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
    nodePackages.node-pre-gyp
    nodejs
    pkg-config
    python3
    nodePackages.pnpm
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
    license = lib.licenses.agpl3;
    maintainers = [ lib.maintainers.ghuntley lib.maintainers.urandom ];
    broken = false;
  };
}
