with import ../../../../.. { };

with lib; let
  # NOTE: the fixed naming scheme must match default.nix
  # name for the URL
  mkURLName = { pname, tlType, ... }: pname + lib.optionalString (tlType != "run" && tlType != "tlpkg") ".${tlType}";
  # name + revision for the fixed output hashes
  mkFixedName = { tlType, revision, extraRevision ? "", ... }@attrs: mkURLName attrs + (lib.optionalString (tlType == "tlpkg") ".tlpkg") + ".r${toString revision}${extraRevision}";

  uniqueByName = fods: catAttrs "fod" (genericClosure {
    startSet = map (fod: { key = fod.name; inherit fod; }) fods;
    operator = _: [ ];
  });

  # ugly hack to extract combine from collection-latexextra, since it is masked by texlive.combine
  combine = lib.findFirst (p: (lib.head p.pkgs).pname == "combine") { pkgs = []; } (lib.head texlive.collection-latexextra.pkgs).tlDeps;
  all = concatLists (map (p: p.pkgs or []) (attrValues (removeAttrs texlive [ "bin" "combine" "combined" "tlpdb" ]))) ++ combine.pkgs;

  # fixed hashes only for run, doc, source, tlpkg types
  fods = sort (a: b: a.name < b.name) (uniqueByName (filter (p: isDerivation p && p.tlType != "bin") all));

  computeHash = fod: runCommand "${fod.name}-fixed-hash"
    { buildInputs = [ nix ]; inherit fod; }
    ''echo -n "$(nix-hash --base32 --type sha256 "$fod")" >"$out"'';

  hash = fod: fod.outputHash or (builtins.readFile (computeHash fod));
  hashLine = fod: ''
    "${mkFixedName fod}"="${hash fod}";
  '';
in
{
  # fixedHashesNix uses 'import from derivation' which does not parallelize well
  # you should build newHashes first, before evaluating (and building) fixedHashesNix
  newHashes = map computeHash (filter (fod: ! fod ? outputHash) fods);

  fixedHashesNix = writeText "fixed-hashes.nix"
  ''
    {
    ${lib.concatMapStrings hashLine fods}}
  '';
}
