{ buildNpmPackage
, fetchFromGitHub
, lib
, esbuild
, buildGoModule
, buildWebExtension ? false
}:
let
  version = "1.5.5";
  gitHash = "9e63da6";
in
buildNpmPackage rec {
  pname = "vencord";
  inherit version;

  src = fetchFromGitHub {
    owner = "Vendicated";
    repo = "Vencord";
    rev = "v${version}";
    sha256 = "sha256-W4pu2ivOxqp0KpXjnYQmFyz+nwRptegHlTra2IsRFQ8=";
  };

  ESBUILD_BINARY_PATH = lib.getExe (esbuild.override {
    buildGoModule = args: buildGoModule (args // rec {
      version = "0.15.18";
      src = fetchFromGitHub {
        owner = "evanw";
        repo = "esbuild";
        rev = "v${version}";
        hash = "sha256-b9R1ML+pgRg9j2yrkQmBulPuLHYLUQvW+WTyR/Cq6zE=";
      };
      vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
    });
  });

  # Supresses an error about esbuild's version.
  npmRebuildFlags = [ "|| true" ];

  makeCacheWritable = true;
  npmDepsHash = "sha256-sNviCa5ld6/ZeH1i/ZAjlsL1VAwJaES8ZdJZn2AYvQ8=";
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

  meta = with lib; {
    description = "Vencord web extension";
    homepage = "https://github.com/Vendicated/Vencord";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ FlafyDev fwam NotAShelf Scrumplex ];
  };
}
