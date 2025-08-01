{
  pkgs ? (import ../../../../.. { }),
}:

let
  inherit (pkgs)
    runCommand
    writeText
    texlive
    nix
    ;
  inherit (pkgs.lib)
    attrValues
    concatMap
    concatMapStrings
    isDerivation
    filter
    optional
    optionalString
    sort
    strings
    ;

  getFods =
    drv:
    optional (isDerivation drv.tex) (drv.tex // { tlType = "run"; })
    ++ optional (drv ? texdoc) (drv.texdoc // { tlType = "doc"; })
    ++ optional (drv ? texsource) (drv.texsource // { tlType = "source"; })
    ++ optional (drv ? tlpkg) (drv.tlpkg // { tlType = "tlpkg"; });

  sorted = sort (a: b: a.pname < b.pname) (attrValues texlive.pkgs);
  fods = concatMap getFods sorted;

  computeHash =
    fod:
    runCommand "${fod.pname}-${fod.tlType}-fixed-hash" {
      buildInputs = [ nix ];
      inherit fod;
    } ''echo -n "$(nix-hash --base32 --type sha256 "$fod")" >"$out"'';

  hash = fod: fod.outputHash or (builtins.readFile (computeHash fod));

  hashes = fods: concatMapStrings ({ tlType, ... }@p: ''${tlType}="${hash p}";'') fods;

  hashLine =
    {
      pname,
      revision,
      extraRevision ? "",
      ...
    }@drv:
    let
      fods = getFods drv;
      # NOTE: the fixed naming scheme must match default.nix
      fixedName = "${pname}-${toString revision}${extraRevision}";
    in
    optionalString (fods != [ ]) ''
      ${strings.escapeNixIdentifier fixedName}={${hashes fods}};
    '';
in
{
  # fixedHashesNix uses 'import from derivation' which does not parallelize well
  # you should build newHashes first, before evaluating (and building) fixedHashesNix
  newHashes = map computeHash (filter (fod: !fod ? outputHash) fods);

  fixedHashesNix = writeText "fixed-hashes.nix" ''
    {
    ${concatMapStrings hashLine sorted}}
  '';
}
