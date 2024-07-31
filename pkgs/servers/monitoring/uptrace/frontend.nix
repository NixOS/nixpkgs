{ stdenvNoCC, callPackage, nodejs, jq, moreutils, nodePackages, cacert }:
let
  common = callPackage ./common.nix { };
in
stdenvNoCC.mkDerivation rec {
  pname = "${common.name}-frontend";
  inherit (common) src version;

  sourceRoot = "source/vue";

  pnpm-deps = stdenvNoCC.mkDerivation {
    pname = "${pname}-pnpm-deps";
    inherit (common) src version;

    sourceRoot = "source/vue";

    nativeBuildInputs = [
      jq
      moreutils
      nodePackages.pnpm
      cacert
    ];

    installPhase = ''
      export HOME=$(mktemp -d)
      pnpm config set store-dir $out
      pnpm install --ignore-scripts

      # Remove timestamp and sort the json files
      rm -rf $out/v3/tmp
      for f in $(find $out -name "*.json"); do
        sed -i -E -e 's/"checkedAt":[0-9]+,//g' $f
        jq --sort-keys . $f | sponge $f
      done
    '';

    dontFixup = true;
    outputHashMode = "recursive";
    outputHash = common.pnpmHash;
  };


  nativeBuildInputs = [
    nodePackages.pnpm
  ];

  configurePhase = ''
    runHook preConfigure

    export HOME=$(mktemp -d)
    pnpm config set store-dir ${pnpm-deps}
    pnpm install --ignore-scripts --offline
    chmod -R +w node_modules

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    pnpm rebuild
    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -R ../vue/dist $out

    runHook postInstall
  '';

  meta = common.meta // {
    description = "Uptrace frontend";
  };
}
