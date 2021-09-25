# Update script: pkgs/development/tools/rust/rust-analyzer/update.sh
{ lib
, vscode-utils
, jq
, rust-analyzer
, nodePackages
, moreutils
, esbuild
, setDefaultServerPath ? true
}:

let
  pname = "rust-analyzer";
  publisher = "matklad";

  build-deps = nodePackages."rust-analyzer-build-deps-../../misc/vscode-extensions/rust-analyzer/build-deps";
  # FIXME: Making a new derivation to link `node_modules` and run `npm run package`
  # will cause a build failure.
  vsix = build-deps.override {
    src = "${rust-analyzer.src}/editors/code";
    outputs = [ "vsix" "out" ];

    releaseTag = rust-analyzer.version;

    nativeBuildInputs = [ jq moreutils esbuild ];

    # Follows https://github.com/rust-analyzer/rust-analyzer/blob/41949748a6123fd6061eb984a47f4fe780525e63/xtask/src/dist.rs#L39-L65
    postInstall = ''
      jq '
        .version = $ENV.version |
        .releaseTag = $ENV.releaseTag |
        .enableProposedApi = false |
        walk(del(.["$generated-start"]?) | del(.["$generated-end"]?))
      ' package.json | sponge package.json

      mkdir -p $vsix
      npx vsce package -o $vsix/${pname}.zip
    '';
  };

  # Use the plugin version as in vscode marketplace, updated by update script.
  inherit (vsix) version;

in
vscode-utils.buildVscodeExtension {
  inherit version vsix;
  name = "${pname}-${version}";
  src = "${vsix}/${pname}.zip";
  vscodeExtUniqueId = "${publisher}.${pname}";

  nativeBuildInputs = lib.optionals setDefaultServerPath [ jq moreutils ];

  preInstall = lib.optionalString setDefaultServerPath ''
    jq '.contributes.configuration.properties."rust-analyzer.server.path".default = $s' \
      --arg s "${rust-analyzer}/bin/rust-analyzer" \
      package.json | sponge package.json
  '';

  meta = with lib; {
    description = "An alternative rust language server to the RLS";
    homepage = "https://github.com/rust-analyzer/rust-analyzer";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ oxalica ];
    platforms = platforms.all;
  };
}
