<<<<<<< HEAD
{ godot3-debug-server }:

godot3-debug-server.overrideAttrs (self: base: {
  pname = "godot3-server";
  godotBuildDescription = "server";
  godotBuildTarget = "release";
=======
{ godot, lib }:
godot.overrideAttrs (oldAttrs: rec {
  pname = "godot-server";
  sconsFlags = [ "target=release" "platform=server" "tools=no" ];
  installPhase = ''
    mkdir -p "$out/bin"
    cp bin/godot_server.* $out/bin/godot-server

    mkdir "$dev"
    cp -r modules/gdnative/include $dev

    mkdir -p "$man/share/man/man6"
    cp misc/dist/linux/godot.6 "$man/share/man/man6/"
  '';
  meta.description =
    "Free and Open Source 2D and 3D game engine (server build)";
  meta.maintainers = with lib.maintainers; [ twey yusdacra ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
})
