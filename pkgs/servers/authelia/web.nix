{ buildNpmPackage, fetchFromGitHub }:

let
  inherit (import ./sources.nix { inherit fetchFromGitHub; }) pname version src npmDepsHash;
in
buildNpmPackage {
  pname = "${pname}-web";
  inherit src version npmDepsHash;

<<<<<<< HEAD
  sourceRoot = "${src.name}/web";
=======
  sourceRoot = "source/web";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  patches = [
    ./change-web-out-dir.patch
  ];

  postPatch = ''
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
