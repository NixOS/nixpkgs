# Update script: pkgs/development/tools/rust/rust-analyzer/update.sh
{ lib, stdenv, vscode-utils, jq, rust-analyzer, nodePackages
, setDefaultServerPath ? true
}:

let
  pname = "rust-analyzer";
  publisher = "matklad";

  # Follow the unstable version of rust-analyzer, since the extension is not stable yet.
  inherit (rust-analyzer) version;

  build-deps = nodePackages."rust-analyzer-build-deps-../../misc/vscode-extensions/rust-analyzer/build-deps";
  # FIXME: Making a new derivation to link `node_modules` and run `npm run package`
  # will cause a build failure.
  vsix = build-deps.override {
    src = "${rust-analyzer.src}/editors/code";
    outputs = [ "vsix" "out" ];

    postInstall = ''
      npm run package
      mkdir $vsix
      cp ${pname}.vsix $vsix/${pname}.zip
    '';
  };

in vscode-utils.buildVscodeExtension {
  inherit version vsix;
  name = "${pname}-${version}";
  src = "${vsix}/${pname}.zip";
  vscodeExtUniqueId = "${publisher}.${pname}";

  nativeBuildInputs = lib.optional setDefaultServerPath jq;

  preInstall = lib.optionalString setDefaultServerPath ''
    jq '.contributes.configuration.properties."rust-analyzer.serverPath".default = $s' \
      --arg s "${rust-analyzer}/bin/rust-analyzer" \
      package.json >package.json.new
    mv package.json.new package.json
  '';

  meta = with lib; {
    description = "An alternative rust language server to the RLS";
    homepage = "https://github.com/rust-analyzer/rust-analyzer";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ oxalica ];
    platforms = platforms.all;
  };
}
