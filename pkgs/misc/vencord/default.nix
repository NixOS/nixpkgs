{ buildNpmPackage
, fetchFromGitHub
, lib
, esbuild
, buildWebExtension ? false
}:
let
  version = "1.6.4";
  gitHash = "6bbf562";
in
buildNpmPackage rec {
  pname = "vencord";
  inherit version;

  src = fetchFromGitHub {
    owner = "Vendicated";
    repo = "Vencord";
    rev = "v${version}";
    hash = "sha256-JL6UwxI4lSkxWfrps1Z2Q97LrzU4Hp6zs8kK2MdqXs8=";
  };

  ESBUILD_BINARY_PATH = lib.getExe (esbuild.overrideAttrs (final: _: {
    version = "0.15.18";
    src = fetchFromGitHub {
      owner = "evanw";
      repo = "esbuild";
      rev = "v${final.version}";
      hash = "sha256-b9R1ML+pgRg9j2yrkQmBulPuLHYLUQvW+WTyR/Cq6zE=";
    };
    vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
  }));

  # Supresses an error about esbuild's version.
  npmRebuildFlags = [ "|| true" ];

  makeCacheWritable = true;
  npmDepsHash = "sha256-nb72XkNlMRJL7BcTh3lf7s0jigRj5F5TeY9xuGAdVsk=";
  npmFlags = [ "--legacy-peer-deps" ];
  npmBuildScript = if buildWebExtension then "buildWeb" else "build";
  npmBuildFlags = [ "--" "--standalone" "--disable-updater" ];

  prePatch = ''
    cp ${./package-lock.json} ./package-lock.json
    chmod +w ./package-lock.json
  '';

  VENCORD_HASH = gitHash;
  VENCORD_REMOTE = "${src.owner}/${src.repo}";

  installPhase =
    if buildWebExtension then ''
      cp -r dist/chromium-unpacked/ $out
    '' else ''
      cp -r dist/ $out
    '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Vencord web extension";
    homepage = "https://github.com/Vendicated/Vencord";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ FlafyDev fwam NotAShelf Scrumplex ];
  };
}
