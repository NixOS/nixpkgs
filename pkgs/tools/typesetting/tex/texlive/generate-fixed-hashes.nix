with import ../../../../.. { };

with lib; let
  isFod = p: p.tlType != "bin" && isDerivation p;

  # ugly hack to extract combine from collection-latexextra, since it is masked by texlive.combine
  combine = lib.findFirst (p: (lib.head p.pkgs).pname == "combine") { pkgs = [ ]; } (lib.head texlive.collection-latexextra.pkgs).tlDeps;
  all = filter (p: p ? pkgs) (attrValues (removeAttrs texlive [ "bin" "combine" "combined" "tlpdb" ])) ++ [ combine ];
  sorted = sort (a: b: (head a.pkgs).pname < (head b.pkgs).pname) all;
  fods = filter isFod (concatMap (p: p.pkgs or [ ]) all);

  computeHash = fod: runCommand "${fod.pname}-${fod.tlType}-fixed-hash"
    { buildInputs = [ nix ]; inherit fod; }
    ''echo -n "$(nix-hash --base32 --type sha256 "$fod")" >"$out"'';

  hash = fod: fod.outputHash or (builtins.readFile (computeHash fod));

  hashes = { pkgs }:
    concatMapStrings ({ tlType, ... }@p: lib.optionalString (isFod p) (''${tlType}="${hash p}";'')) pkgs;

  hashLine = { pkgs }@pkg:
    let
      fods = lib.filter isFod pkgs;
      first = lib.head fods;
      # NOTE: the fixed naming scheme must match default.nix
      fixedName = with first; "${pname}-${toString revision}${first.extraRevision or ""}";
    in
    lib.optionalString (fods != [ ]) ''
      ${strings.escapeNixIdentifier fixedName}={${hashes pkg}};
    '';
in
{
  # fixedHashesNix uses 'import from derivation' which does not parallelize well
  # you should build newHashes first, before evaluating (and building) fixedHashesNix
  newHashes = map computeHash (filter (fod: ! fod ? outputHash) fods);

  fixedHashesNix = writeText "fixed-hashes.nix"
    ''
      {
      ${lib.concatMapStrings hashLine sorted}}
    '';
}
