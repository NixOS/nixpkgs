{
  buildGoModule,
  callPackage,
  nodejs,
  pnpm,
}:
let
  common = callPackage ./common.nix { };

  nodeModulesHash = "sha256-34N20FvgBbJAa28u56ZrYrT16J/+8OPuIm1O7EYGVc0=";

  pnpmDeps = pnpm.fetchDeps {
    inherit (common) version;
    src = "${common.src}/web";
    pname = "woodpecker-webui";
    fetcherVersion = 1;
    hash = nodeModulesHash;
  };
in
buildGoModule {
  pname = "woodpecker-server";
  inherit (common)
    version
    src
    ldflags
    postInstall
    vendorHash
    ;
  inherit pnpmDeps;

  subPackages = "cmd/server";

  env.CGO_ENABLED = 1;

  nativeBuildInputs = [
    nodejs
    pnpm
  ];

  postConfigure = ''
    pushd web
    export HOME=$(mktemp -d)
    pnpm config set store-dir ${pnpmDeps}
    pnpm install --offline --frozen-lockfile --ignore-script
    popd
  '';

  preBuild = ''
    if [ -d web/node_modules ]; then
      pushd web
      pnpm build
      popd
    fi
  '';

  passthru = {
    updateScript = ./update.sh;
  };

  meta = common.meta // {
    description = "Woodpecker Continuous Integration server";
    mainProgram = "woodpecker-server";
  };
}
