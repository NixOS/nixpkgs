# Update script: pkgs/development/tools/rust/rust-analyzer/update.sh
{ lib, pkgs, stdenv, nodejs, vscode-utils, jq, rust-analyzer
, setDefaultRaLspServerPath ? true
}:

let
  pname = "rust-analyzer";
  publisher = "matklad";

  # Follow the unstable version of rust-analyzer, since the extension is not stable yet.
  inherit (rust-analyzer) version;

  vsix = (import ./node-composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  }).package.override {
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

  nativeBuildInputs = lib.optional setDefaultRaLspServerPath jq;

  postFixup = lib.optionalString setDefaultRaLspServerPath ''
    package_json="$out/share/vscode/extensions/${publisher}.${pname}/package.json"
    jq '.contributes.configuration.properties."rust-analyzer.serverPath".default = $s' \
      --arg s "${rust-analyzer}/bin/rust-analyzer" \
      $package_json >$package_json.new
    mv $package_json.new $package_json
  '';

  meta = with lib; {
    description = "An alternative rust language server to the RLS";
    homepage = "https://github.com/rust-analyzer/rust-analyzer";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ oxalica ];
    platforms = platforms.all;
  };
}
