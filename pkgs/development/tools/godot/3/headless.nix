{ godot, lib }:
godot.overrideAttrs (oldAttrs: rec {
  pname = "godot-headless";
  sconsFlags = [ "target=release_debug" "platform=server" "tools=yes" ];
  installPhase = ''
    mkdir -p "$out/bin"
    cp bin/godot_server.* $out/bin/godot-headless

    mkdir "$dev"
    cp -r modules/gdnative/include $dev

    mkdir -p "$man/share/man/man6"
    cp misc/dist/linux/godot.6 "$man/share/man/man6/"
  '';
  meta.description =
    "Free and Open Source 2D and 3D game engine (headless build)";
  meta.maintainers = with lib.maintainers; [ twey yusdacra ];
})
