{ stdenv
, jq, nixpkgs-fmt, vscode-utils}:

let
  inherit (vscode-utils) buildVscodeMarketplaceExtension;
in
buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "nixpkgs-fmt";
    publisher = "B4dM4n";
    version = "0.0.1";
    sha256 = "bf3da4537e81d7190b722d90c0ba65fd204485f49696d203275afb4a8ac772bf";
  };

  nativeBuildInputs = [
    jq
  ];

  preInstall = ''
    jq '.contributes.configuration.properties."nixpkgs-fmt.path".default = $s' \
      --arg s "${nixpkgs-fmt}/bin/nixpkgs-fmt" \
      package.json >package.json.new
    mv package.json.new package.json
  '';

  meta = with stdenv.lib; {
    description = "Format nix files with nixpkgs-fmt";
    homepage = "https://github.com/B4dM4n/vscode-nixpkgs-fmt";
    license = licenses.mit;
    maintainers = with maintainers; [ zeratax ];
  };
}
