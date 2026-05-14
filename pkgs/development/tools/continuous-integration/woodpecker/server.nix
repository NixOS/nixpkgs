{
  buildGoModule,
  callPackage,
}:
let
  common = callPackage ./common.nix { };
in
buildGoModule (finalAttrs: {
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

  postPatch = ''
    cp -r ${finalAttrs.passthru.webui} web/dist
  '';

  passthru = {
    webui = callPackage ./webui.nix { };
    updateScript = ./update.sh;
  };

  meta = common.meta // {
    description = "Woodpecker Continuous Integration server";
    mainProgram = "woodpecker-server";
  };
})
