{ buildNpmPackage
, fetchFromGitHub
, lib
, esbuild
, buildGoModule
, buildWebExtension ? false
}:
let
  version = "1.4.7";
  gitHash = "25a1d93";
in
buildNpmPackage rec {
  pname = "vencord";
  inherit version;

  src = fetchFromGitHub {
    owner = "Vendicated";
    repo = "Vencord";
    rev = "v${version}";
    sha256 = "sha256-bSLPZJyBKws+6IE4YTgQTMau5yKpHJdq5tw6Jg1Uc/s=";
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

  npmDepsHash = "sha256-GoVVOLg20oi0MJGLqevpiqHDM/7yaRJSQnM/tt+AkQ8=";
  npmFlags = [ "--legacy-peer-deps" ];
  npmBuildScript = if buildWebExtension then "buildWeb" else "build";
  npmBuildFlags = [ "--" "--standalone" "--disable-updater" ];

  prePatch = ''
    cp ${./package-lock.json} ./package-lock.json
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
    maintainers = with maintainers; [ FlafyDev NotAShelf Scrumplex ];
  };
}
