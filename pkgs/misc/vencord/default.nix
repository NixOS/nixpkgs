{ buildNpmPackage
, fetchFromGitHub
, lib
, substituteAll
, esbuild
, buildGoModule
, buildWebExtension ? false
}:
buildNpmPackage rec {
  pname = "vencord";
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "Vendicated";
    repo = "Vencord";
    rev = "v${version}";
    sha256 = "sha256-AqzhTzfqbYotQxLrkhkjvSPB4irL/q2fxXusWgCibpI=";
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

  npmDepsHash = "sha256-Sj74qx9Tdz1EsoOVqk4ZdXTXxB4ShrFl3VRCWJ6/KcQ=";
  npmFlags = [ "--legacy-peer-deps" ];
  npmBuildScript = if buildWebExtension then "buildWeb" else "build";

  prePatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  patches = [
    (substituteAll {
      src = ./replace-git.patch;
      inherit version;
    })
  ];

  installPhase = if buildWebExtension then ''
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
