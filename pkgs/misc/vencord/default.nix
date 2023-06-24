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
  version = "1.2.8";

  src = fetchFromGitHub {
    owner = "Vendicated";
    repo = "Vencord";
    rev = "v${version}";
    sha256 = "sha256-l3h4LrpMQ944i4QivKeL3dhZxZCr5uG29pQMY1XNbqc=";
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

  npmDepsHash = "sha256-m+hczXog03Gz81CP/blkRJPaTrEhmLQFvVtOfWKYQL4=";
  npmFlags = [ "--legacy-peer-deps" ];
  npmBuildScript = if buildWebExtension then "buildWeb" else "build";
  npmBuildFlags = [ "--" "--standalone" ];

  prePatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  patches = [
    (substituteAll {
      src = ./replace-git.patch;
      inherit version;
    })
    ./disable-updater-ui.patch
  ];

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
