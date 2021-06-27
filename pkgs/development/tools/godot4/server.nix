{ godot, lib }:

godot.overrideAttrs (oldAttrs: rec {
  pname = "godot-server";
  sconsFlags = "target=release platform=server tools=no";
  installPhase = ''
    mkdir -p $out/bin $dev
    cp bin/godot_server.* $out/bin/godot-server
    cp -r modules/gdnative/include $dev
    cp misc/dist/linux/godot.6 "$man/share/man/man6/"
  '';
  meta.description = "Free and Open Source 2D and 3D game engine (server build)";
  meta.maintainers = with lib.maintainers; [ twey yusdacra ];
})
