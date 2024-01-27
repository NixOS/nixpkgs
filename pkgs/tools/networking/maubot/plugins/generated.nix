{ lib
, fetchgit
, fetchFromGitHub
, fetchFromGitLab
, fetchFromGitea
, python3
, poetry
, buildMaubotPlugin
}:

let
  json = builtins.fromJSON (builtins.readFile ./generated.json);
in

lib.flip builtins.mapAttrs json (name: entry:
let
  inherit (entry) manifest;

  resolveDeps = deps: map
    (name:
      let
        packageName = builtins.head (builtins.match "([^~=<>]*).*" name);
        lower = lib.toLower packageName;
        dash = builtins.replaceStrings ["_"] ["-"] packageName;
        lowerDash = builtins.replaceStrings ["_"] ["-"] lower;
      in
        python3.pkgs.${packageName}
        or python3.pkgs.${lower}
        or python3.pkgs.${dash}
        or python3.pkgs.${lowerDash}
        or null)
    (builtins.filter (x: x != "maubot" && x != null) deps);

  reqDeps = resolveDeps (lib.toList (manifest.dependencies or null));
  optDeps = resolveDeps (lib.toList (manifest.soft_dependencies or null));
in

lib.makeOverridable buildMaubotPlugin (entry.attrs // {
  pname = manifest.id;
  inherit (manifest) version;

  src =
    if entry?github then fetchFromGitHub entry.github
    else if entry?git then fetchgit entry.git
    else if entry?gitlab then fetchFromGitLab entry.gitlab
    else if entry?gitea then fetchFromGitea entry.gitea
    else throw "Invalid generated entry for ${manifest.id}: missing source";

  propagatedBuildInputs = builtins.filter (x: x != null) (reqDeps ++ optDeps);

  passthru.isOfficial = entry.isOfficial or false;

  meta = entry.attrs.meta // {
    license =
      let
        spdx = entry.attrs.meta.license or manifest.license or "unfree";
        spdxLicenses = builtins.listToAttrs
          (map (x: lib.nameValuePair x.spdxId x) (builtins.filter (x: x?spdxId) (builtins.attrValues lib.licenses)));
      in
      spdxLicenses.${spdx};
    broken = builtins.any (x: x == null) reqDeps;
  };
} // lib.optionalAttrs (entry.isPoetry or false) {
  nativeBuildInputs = [
    poetry
    (python3.withPackages (p: with p; [ toml ruamel-yaml isort ]))
  ];

  preBuild = lib.optionalString (entry?attrs.preBuild) (entry.attrs.preBuild + "\n") + ''
    export HOME=$(mktemp -d)
    [[ ! -d scripts ]] || patchShebangs --build scripts
    make maubot.yaml
  '';
}))
