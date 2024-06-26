{ buildNpmPackage, fetchFromGitHub }:

let
  inherit (import ./sources.nix { inherit fetchFromGitHub; })
    pname
    version
    src
    npmDepsHash
    ;
in
buildNpmPackage {
  pname = "${pname}-web";
  inherit src version npmDepsHash;

  sourceRoot = "${src.name}/web";

  postPatch = ''
    substituteInPlace ./vite.config.ts \
      --replace 'outDir: "../internal/server/public_html"' 'outDir: "dist"'
    cp ${./package-lock.json} ./package-lock.json
  '';

  npmFlags = [ "--legacy-peer-deps" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    mv dist $out/share/authelia-web

    runHook postInstall
  '';
}
