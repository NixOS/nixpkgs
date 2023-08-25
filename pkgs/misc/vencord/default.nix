{ buildNpmPackage
, fetchFromGitHub
, fetchpatch2
, lib
, esbuild
, buildGoModule
, buildWebExtension ? false
}:
let
  version = "1.4.5";
  gitHash = "98a03c8";
in
buildNpmPackage rec {
  pname = "vencord";
  inherit version;

  src = fetchFromGitHub {
    owner = "Vendicated";
    repo = "Vencord";
    rev = "v${version}";
    sha256 = "sha256-ZoHOCl0j+RBSl2lL9wO2rJ8VR+GNIeWJYe65c3lVoz8=";
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

  npmDepsHash = "sha256-51IK95QY9YX0WerGu4GuOrYKoj8Uoo0R1b6WZpC5v4U=";
  npmFlags = [ "--legacy-peer-deps" ];
  npmBuildScript = if buildWebExtension then "buildWeb" else "build";
  npmBuildFlags = [ "--" "--standalone" "--disable-updater" ];

  prePatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  patches = [
    (fetchpatch2 {
      name = "allow-git-hash-remote-preset.patch";
      url = "https://github.com/Vendicated/Vencord/commit/d9f55664428007199348123b05818f9e08c4f64d.patch";
      hash = "sha256-l4PP8nVtyQJYUqtU9xYGT4j1Oayy08DE6TfbwPun0pY=";
    })
    (fetchpatch2 {
      name = "use-source-date-epoch.patch";
      url = "https://github.com/Vendicated/Vencord/commit/28247c88a949eeaac75b13a8d6653164d9659f56.patch";
      hash = "sha256-mMpsB3GkI9LUiMQ/NFOiRw4z+wVkktmWgUHNTgxUFPU=";
    })
    (fetchpatch2 {
      name = "allow-disabling-updater.patch";
      url = "https://github.com/Vendicated/Vencord/commit/bad1fa0c766b2d42cd2eb0e0d1ab2e0c381bab98.patch";
      hash = "sha256-yp453kFvVC02QEB3Op8PfopnLt3xGkjp4WfP6kPeIJ0=";
    })
  ];

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
