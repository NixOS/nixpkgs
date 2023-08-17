with import ../../../../.. { };

with lib; let
  # ugly hack to extract combine from collection-latexextra, since it is masked by texlive.combine
  combine = lib.findFirst (p: p.pname == "combine") { } texlive.collection-latexextra.tlDeps;

  # collect and sort all packages
  all = filter (p: p ? tlOutputName) (attrValues (removeAttrs texlive [ "bin" "combine" "combined" "tlpdb" ])) ++ [ combine ];
  sorted = sort (a: b: a.pname < b.pname) all;

  computeHash = { pname, revision, tlOutputName, ... }@fod:
    runCommand "${pname}-${revision}-${tlOutputName}-fixed-hash"
      { buildInputs = [ nix ]; inherit fod; }
      ''echo -n "$(nix-hash --base32 --type sha256 "$fod")" >"$out"'';

  hash = fod: fod.outputHash or (builtins.readFile (computeHash fod));

  hashes = tex:
    lib.optionalString (isDerivation tex) ''run="${hash tex}";'' +
    lib.optionalString (tex ? texdoc) ''doc="${hash tex.texdoc}";'' +
    lib.optionalString (tex ? texsource) ''source="${hash tex.texsource}";'' +
    lib.optionalString (tex ? tlpkg) ''tlpkg="${hash tex.tlpkg}";'';

  # NOTE: the fixed naming scheme must match default.nix
  hashLine = tex: ''
    ${strings.escapeNixIdentifier "${tex.pname}-${tex.revision}"}={${hashes tex}};
  '';
in
{
  # fixedHashesNix uses 'import from derivation' which does not parallelize well
  # you should build newHashes first, before evaluating (and building) fixedHashesNix
  newHashes = map computeHash (filter (fod: ! fod ? outputHash) sorted);

  fixedHashesNix = writeText "fixed-hashes.nix"
    ''
      {
      ${lib.concatMapStrings hashLine sorted}}
    '';
}
