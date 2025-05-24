{
  lib,
  recurseIntoAttrs,

  cmark,
  formats,
  nixosOptionsDoc,
  runCommand,
  _cuda,

  cudaPackages,

  cudaPackages_11_4,
  cudaPackages_11_5,
  cudaPackages_11_6,
  cudaPackages_11_7,
  cudaPackages_11_8,
  cudaPackages_11,

  cudaPackages_12_0,
  cudaPackages_12_1,
  cudaPackages_12_2,
  cudaPackages_12_3,
  cudaPackages_12_4,
  cudaPackages_12_5,
  cudaPackages_12_6,
  cudaPackages_12_8,
  cudaPackages_12,
}@args:

let
  isTest =
    name: package:
    builtins.elem (package.pname or null) [
      "cuda-samples"
      "cuda-library-samples"
      "saxpy"
    ];

  inherit (_cuda) db dbEvaluation;
  # Based on nixos/doc/manual/default.nix
  prefixesToStrip = [ ((toString dbEvaluation._module.specialArgs.modulesPath or ../../../.) + "/") ];
  stripAnyPrefixes = lib.flip (lib.foldr lib.removePrefix) prefixesToStrip;
  dbDocs = nixosOptionsDoc {
    inherit (dbEvaluation) options;
    transformOptions = opt: opt // { declarations = map stripAnyPrefixes opt.declarations; };
  };
in
(lib.trivial.pipe args [
  (lib.filterAttrs (name: _: lib.hasPrefix "cudaPackages" name))
  (lib.mapAttrs (
    _: ps:
    lib.pipe ps [
      (lib.filterAttrs isTest)
      recurseIntoAttrs
    ]
  ))
  recurseIntoAttrs
])
// {
  db = (formats.json { }).generate "cudb.json" dbEvaluation.validConfig;
  dbDocs = dbDocs // {
    html =
      runCommand "cudb-options.html"
        {
          nativeBuildInputs = [ cmark ];
          src = dbDocs.optionsCommonMark;
        }
        ''
          cat << EOF > "$out"
          <!DOCTYPE html>
          <html>
          <head><meta charset="utf-8"></head>
          <body>
          EOF

          cmark "$src" >> "$out"

          echo "</body></html>" >> "$out"
        '';
  };
}
