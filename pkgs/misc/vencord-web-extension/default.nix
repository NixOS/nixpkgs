{ buildNpmPackage
, fetchFromGitHub
, lib
, substituteAll
, esbuild
, buildGoModule
}:
buildNpmPackage rec {
  pname = "vencord-web-extension";
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "Vendicated";
    repo = "Vencord";
    rev = "v${version}";
    sha256 = "sha256-V9fzSoRqVlk9QqpzzR2x+aOwGHhQhQiSjXZWMC0uLnQ=";
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

  npmDepsHash = "sha256-jKSdeyQ8oHw7ZGby0XzDg4O8mtH276ykVuBcw7dU/Ls=";
  npmFlags = [ "--legacy-peer-deps" ];
  npmBuildScript = "buildWeb";

  prePatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  patches = [
    (substituteAll {
      src = ./replace-git.patch;
      inherit version;
    })
  ];

  installPhase = ''
    cp -r dist/extension-unpacked $out
  '';

  meta = with lib; {
    description = "Vencord web extension";
    homepage = "https://github.com/Vendicated/Vencord";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ FlafyDev NotAShelf ];
  };
}
