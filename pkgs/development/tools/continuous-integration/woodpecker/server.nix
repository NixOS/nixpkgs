<<<<<<< HEAD
{
  buildGoModule,
  callPackage,
}:
let
  common = callPackage ./common.nix { };
in
buildGoModule (finalAttrs: {
=======
{ buildGoModule, callPackage }:
let
  common = callPackage ./common.nix { };
in
buildGoModule {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "woodpecker-server";
  inherit (common)
    version
    src
    ldflags
    postInstall
    vendorHash
    ;

  subPackages = "cmd/server";

  env.CGO_ENABLED = 1;

<<<<<<< HEAD
  postPatch = ''
    cp -r ${finalAttrs.passthru.webui} web/dist
  '';

  passthru = {
    webui = callPackage ./webui.nix { };
=======
  passthru = {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    updateScript = ./update.sh;
  };

  meta = common.meta // {
    description = "Woodpecker Continuous Integration server";
    mainProgram = "woodpecker-server";
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
